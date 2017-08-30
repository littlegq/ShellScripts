#!/bin/sh
#$ -N SampleID
#$ -j y
#$ -o SampleID.out
#$ -cwd
#$ -V
#$ -q all.q
#$ -M qgong@coh.org
#$ -m as


bmdir="/home/qgong/bin/bismark_v0.12.5"
bismark="$bmdir/bismark"
bismark_genome_preparation="$bmdir/bismark_genome_preparation"
bismark_methylation_extractor="$bmdir/bismark_methylation_extractor"
bt2refdir="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Sequence/Bowtie2Index"

pfx="SampleID"
rawdir="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/RawData/T.Cell.RRBS"
r1="$rawdir/$pfx.R1_val_1.fq.gz"
r2="$rawdir/$pfx.R2_val_2.fq.gz"

# alignment 

$bismark $bt2refdir --bowtie2 -1 $r1 -2 $r2
$bismark_methylation_extractor -p --bedGraph --counts --comprehensive --buffer_size 8G $pfx.R1_val_1.fq.gz_bismark_bt2_pe.sam
