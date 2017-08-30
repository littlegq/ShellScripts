#!/bin/sh
#$ -N SampleID
#$ -j y
#$ -o SampleID.out
#$ -cwd
#$ -V
#$ -q short.q
#$ -M qgong@coh.org


kallisto="/home/qgong/bin/kallisto"

name="SampleID"

$kallisto quant -i TCR_index -o $name ../Rawdata/$name.R1.fastq.gz ../Rawdata/$name.R2.fastq.gz


