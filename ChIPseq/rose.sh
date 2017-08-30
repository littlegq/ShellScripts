#!/bin/sh

datadir="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/T.Epi/Enhancer"
cd /net/isi-dcnl/ifs/user_data/jochan/Group/qgong/bin/rose
for name in `cat $datadir/SampleID.txt`
do
#	quick_qsub.pl =$name= {-pe shared 4} $"python ROSE_main.py -g HG19 -i $datadir/$name.H3K27ac.gff -r $datadir/$name.H3K27ac.sort.bam -c $datadir/$name.input.sort.bam -o $datadir/$name -s 12500 -t 2500"
	python ROSE_main.py -g HG19 -i $datadir/$name.H3K27ac.gff -r $datadir/$name.H3K27ac.sort.bam -c $datadir/$name.input.sort.bam -o $datadir/$name -s 12500 -t 2500
done

cd $datadir


