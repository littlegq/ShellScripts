#!/bin/sh
#$ -N ExperimentID
#$ -j y
#$ -o ExperimentID.out
#$ -cwd
#$ -V
#$ -q all.q
#$ -pe shared 4
#$ -M qgong@coh.org

bdgdir="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/ChIPseq/Peaks"
pfx="ExperimentID"
G1kbed="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/HighExpGene1K/G1kPromoters.bed"
sort -k1,1 -k2,2n $bdgdir/$pfx/$pfx"_treat_pileup.bdg" > $pfx.treat.bdg
sort -k1,1 -k2,2n  $bdgdir/$pfx/$pfx"_control_lambda.bdg" > $pfx.control.bdg
bedtools intersect -loj -sorted -a $G1kbed -b $pfx.treat.bdg > $pfx.G1kP.treat.bed
bedtools intersect -loj -sorted -a $G1kbed -b $pfx.control.bdg > $pfx.G1kP.control.bed
reorder_columns.pl $pfx.G1kP.treat.bed 7-9,4,10 > $pfx.G1kP.treat.bed.1
mv $pfx.G1kP.treat.bed.1 $pfx.G1kP.treat.bed
reorder_columns.pl $pfx.G1kP.control.bed 7-9,4,10 > $pfx.G1kP.control.bed.1
mv $pfx.G1kP.control.bed.1 $pfx.G1kP.control.bed
bedtools intersect -loj -a $pfx.G1kP.treat.bed -b $pfx.G1kP.control.bed > $pfx.G1kP.compare.bed
./MedianPromoterRatio.pl $pfx.G1kP.compare.bed > $pfx.G1kP.PmtRatio.txt

