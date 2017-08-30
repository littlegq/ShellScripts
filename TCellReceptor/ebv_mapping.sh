#!/bin/bash
#$ -N SampleID
#$ -j y
#$ -o SampleID.out
#$ -cwd
#$ -V
#$ -q all.q


mkfifo="/usr/bin/mkfifo"


pfx="SampleID"

rawdatadir="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/TCR/Rawdata"
r1="$rawdatadir/$pfx.R1.fastq.gz"
r2="$rawdatadir/$pfx.R2.fastq.gz"
ref="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/Genomes/AJ507799.2/AJ507799.2.fa"
threads="1"
memory="32"
samtools="/opt/icas-0.6.1/bin/samtools"
bwa="/opt/bwa-0.7.5a/bin/bwa"

indel="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf"
dbsnp="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/hg19/dbsnp_138.hg19.vcf"
gatk="/home/qgong/bin/GATK/GenomeAnalysisTK.jar"
picard="/home/qgong/bin/picard-tools-1.115"
varscan="/home/qgong/bin/VarScan.v2.3.6.jar"

inbam="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/FLtFL/BAMs/$pfx.sort.bam"

######################### 


echo "[`date`] Read aligning for $pfx using BWA aln"
$mkfifo $pfx.r1sai.fifo $pfx.r2sai.fifo
$bwa aln -t $threads $ref $r1 > $pfx.r1sai.fifo &
$bwa aln -t $threads $ref $r2 > $pfx.r2sai.fifo &
echo "[`date`] Pair-end mapping for $pfx using BWA sampe"
$bwa sampe $ref $pfx.r1sai.fifo $pfx.r2sai.fifo $r1 $r2 -f $pfx.sam

echo "[`date`] Transforming SAM file to BAM file using Samtools view"
$samtools view -Sb $pfx.sam > $pfx.bam
rm $pfx.sam
echo "[`date`] Sorting the BAM file using Samtools sort"
$samtools sort $pfx.bam $pfx.sort
echo "[`date`] Indexing the sorted BAM file using Samtools index"
$samtools index $pfx.sort.bam

echo "[`date`] flagstating"
$samtools flagstat $pfx.sort.bam > $pfx.sort.bam.flagstat

/home/qgong/bin/calDepth $pfx.sort.bam > $pfx.depth 
if ! [ -d "$pfx" ]
then
	mkdir $pfx
fi
mv $pfx.* $pfx


	

