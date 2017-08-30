#!/bin/bash
#$ -N SampleID
#$ -j y
#$ -o SampleID.out
#$ -cwd
#$ -V
#$ -q all.q
#$ -pe shared 4
#$ -M qgong@coh.org

mkfifo="/usr/bin/mkfifo"

pfx="SampleID"

rawdatadir="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/B.Mut/DLBCL.Song/Rawdata"
r1="$rawdatadir/$pfx.R1.fastq.gz"
r2="$rawdatadir/$pfx.R2.fastq.gz"
bwaref="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/NewHG19/hg19.all.fa"
ref="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/NewHG19/hg19.all.fa"
threads="4"
memory="16"
samtools="/opt/icas-0.6.1/bin/samtools"
bwa="/opt/bwa-0.7.5a/bin/bwa"

indel="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf"
dbsnp="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/hg19/dbsnp_138.hg19.vcf"
gatk="/home/qgong/bin/GATK/GenomeAnalysisTK.jar"
picard="/home/qgong/bin/picard-tools-1.115"
varscan="/home/qgong/bin/VarScan.v2.3.6.jar"

inbam="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/FLtFL/BAMs/$pfx.sort.bam"

######################### 

echo "[`date`] Job starting"
echo "[`date`] Read aligning for $pfx using BWA mem"
# $bwa mem -t $threads $bwaref $r1 $r2 > $pfx.sam

echo "[`date`] Transforming SAM file to BAM file using Samtools view"
# $samtools view -Sb $pfx.sam > $pfx.bam
# rm $pfx.sam

echo "PostMapping For $pfx"
echo "[`date`] Sorting BAMs using PicardTools SortSam.jar for $pfx."
java -Djava.io.tmpdir=`pwd`/tmp -Xmx${memory}g -jar $picard/SortSam.jar INPUT=$pfx.bam OUTPUT=$pfx.sorted.bam SO=coordinate VALIDATION_STRINGENCY=SILENT
rm $pfx.sam
echo "[`date`] Marking Duplicates using PicardTools MarkDuplicates.jar for $pfx."
java -Djava.io.tmpdir=`pwd`/tmp -Xmx${memory}g -jar $picard/MarkDuplicates.jar INPUT=$pfx.sorted.bam OUTPUT=$pfx.dup_marked.bam M=$pfx.metric SORTING_COLLECTION_SIZE_RATIO=0.125 VALIDATION_STRINGENCY=SILENT
echo "[`date`] Fixing Read Group in the bam file using PicardTools AddOrReplaceReadGroups.jar for $pfx."
java -Djava.io.tmpdir=`pwd`/tmp -Xmx${memory}g -jar $picard/AddOrReplaceReadGroups.jar I=$pfx.dup_marked.bam O=$pfx.fixed_RG.bam SO=coordinate RGID=$pfx RGLB=$pfx RGPL=illumina RGPU=$pfx RGSM=$pfx VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true
rm $pfx.dup_marked.bam
rm $pfx.sorted.bam
rm $pfx.metric
echo "[`date`] Creating realignment targets - needed for indel realignment - using GATK RealignerTargetCreator for $pfx"
java -Djava.io.tmpdir=`pwd`/tmp -Xmx${memory}g -jar $gatk -T RealignerTargetCreator -R $ref -I $pfx.fixed_RG.bam -known $indel -o $pfx.indel_realigner.intervals
echo "[`date`] Realigning around indels using GATK IndelRealigner for $pfx"
java -Djava.io.tmpdir=`pwd`/tmp -Xmx${memory}g -jar $gatk -T IndelRealigner -R $ref -I $pfx.fixed_RG.bam -known $indel -o $pfx.realigned.bam -targetIntervals $pfx.indel_realigner.intervals
rm $pfx.fixed_RG.bam $pfx.fixed_RG.bai
echo "[`date`] Building recalibration model using GATK BaseRecalibrator for $pfx"
java -Djava.io.tmpdir=`pwd`/tmp -Xmx${memory}g -jar $gatk -T BaseRecalibrator -R $ref -I $pfx.realigned.bam --knownSites $dbsnp --knownSites $indel -o $pfx.recal.table
echo "[`date`] Creating a new bam file using GATK PrintReads for $pfx"
java -Djava.io.tmpdir=`pwd`/tmp -Xmx${memory}g -jar $gatk -T PrintReads -R $ref -I $pfx.realigned.bam -BQSR $pfx.recal.table -o $pfx.recal.bam
echo "[`date`] Secondly Building recalibration model using GATK BaseRecalibrator for $pfx"
java -Djava.io.tmpdir=`pwd`/tmp -Xmx${memory}g -jar $gatk -T BaseRecalibrator -R $ref -I $pfx.realigned.bam --knownSites $dbsnp --knownSites $indel -BQSR $pfx.recal.table -o $pfx.after_recal.table
echo "[`date`] Making plots based on before/after recalibrated tables using GATK AnalyzeCovariates for $pfx"
java -Djava.io.tmpdir=`pwd`/tmp -Xmx${memory}g -jar $gatk -T AnalyzeCovariates -R $ref -before $pfx.recal.table -after $pfx.after_recal.table -plots $pfx.recal_plots.pdf
rm $pfx.realigned.bam $pfx.realigned.bai
rm $pfx.indel_realigner.intervals
rm $pfx.recal.table
rm $pfx.after_recal.table
$samtools flagstat $pfx.recal.bam > $pfx.recal.bam.flagstat

