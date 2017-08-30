#!/bin/bash

mkfifo="/usr/bin/mkfifo"


pfx="RNA131"
sam_group_for_cuffnorm=`cat BamList.txt`
groups=`cat group_names.txt`

rawdatadir="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/NK.RNAseq/Rawdata"
r1="$rawdatadir/$pfx.R1.fastq.gz"
r2="$rawdatadir/$pfx.R2.fastq.gz"
bwaref="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Sequence/BWAIndex/genome.fa"
bt2refpfx="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Sequence/Bowtie2Index/genome"
ref="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Sequence/WholeGenomeFasta/genome.fa"
gtf="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Annotation/Genes/tcr.gtf"
threads="8"
memory="32"

indel="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf"
dbsnp="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/hg19/dbsnp_138.hg19.vcf"
gatk="/home/qgong/bin/GATK/GenomeAnalysisTK.jar"
picard="/home/qgong/bin/picard-tools-1.115"
varscan="/home/qgong/bin/VarScan.v2.3.6.jar"
cuffdir="/home/qgong/bin/cufflinks-2.2.1.Linux_x86_64"
cufflinks="$cuffdir/cufflinks"
cuffmerge="$cuffdir/cuffmerge"
cuffdiff="$cuffdir/cuffdiff"
cuffnorm="$cuffdir/cuffnorm"

inbam="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/FLtFL/BAMs/$pfx.sort.bam"


######################### 


echo "[`date`] Job starting"

echo "[`date`] Map the reads for each sample to the reference genome with Tophat"
$tophat -p $threads -G $gtf -o $pfx.thout $bt2refpfx $r1 $r2

echo "[`date`] Assemble transcripts for each sample with cufflinks"
$cufflinks -p $threads -o $pfx.clout $pfx.thout/accepted_hits.bam 

echo "[`date`] Run Cuffnorm by using the merged transcriptome assembly along with the BAM files from TopHat for each replicate"
$cuffnorm -o $pfx.normout -p $threads -L $groups $gtf $sam_group_for_cuffnorm 

echo "[`date`] Job End"

