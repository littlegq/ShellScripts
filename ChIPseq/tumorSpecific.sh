#!/bin/sh

for name in `cat AITL.SampleID.H3K27ac.Qualified.txt`
do
	bedtools subtract -a $name.enhancers.topGene.bed -b Tonsil.H3K27ac_peaks.broadPeak -A -f 0.05 | bedtools subtract -a - -b Tonsil.enhancers.topGene.bed -A -f 0.05  > $name.enhancer.Gain.bed # up in tumor
	bedtools subtract -a Tfh.enhancers.topGene.bed -b $name.H3K27ac_peaks.broadPeak -A -f 0.05 | bedtools subtract -a - -b $name.enhancers.topGene.bed -A -f 0.05 > $name.enhancer.Loss.bed # down in tumor 
done

output="AITL.enhancer.Loss.txt"
if [ -f $output ]
then
	rm $output
fi
for name in `cat AITL.SampleID.H3K27ac.Qualified.txt`
do
	echo $name >> $output
	cat $name.enhancer.Loss.bed >> $output
done
AddSampleIDColumn.pl $output > $output.1
mv $output.1 $output

output="AITL.enhancer.Gain.txt"
if [ -f $output ]
then
	rm $output
fi
for name in `cat AITL.SampleID.H3K27ac.Qualified.txt`
do
	echo $name >> $output
	cat $name.enhancer.Gain.bed >> $output
done
AddSampleIDColumn.pl $output > $output.1
mv $output.1 $output

	
