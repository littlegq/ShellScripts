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

bamdir="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/B.Mut/DLBCL.Song/BAM"
bam="$bamdir/$pfx.recal.bam"

bwaref="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Sequence/BWAIndex/genome.fa"
ref="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Sequence/WholeGenomeFasta/genome.fa"
threads="4"
memory="32"
samtools="/opt/samtools-1.4.1/bin/samtools"
bwa="/opt/bwa-0.7.5a/bin/bwa"

indel="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf"
dbsnp="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/hg19/dbsnp_138.hg19.vcf"
gatk="/home/qgong/bin/GATK/GenomeAnalysisTK.jar"
picard="/home/qgong/bin/picard-tools-1.115"
varscan="/home/qgong/bin/VarScan.v2.3.6.jar"
somaticID="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/bin/somaticID/somaticID.pl"
annovardir="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/bin/annovar"

######################### 

$somaticID -o $pfx -ref $ref --annovardir $annovardir --rmAdjErr 5 --selfmodel --tmpjava ./tmp $bam
