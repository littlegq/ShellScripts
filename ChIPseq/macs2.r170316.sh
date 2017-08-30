#!/bin/sh

# grep 'H3K27ac' ../BAMs/ExperimentID.r170316.sh | sed 's/.H3K27ac//g' > SampleID.H3K27ac.r170316.txt
# grep 'H3K27me3' ../BAMs/ExperimentID.r170316.sh | sed 's/.H3K27me3//g' > SampleID.H3K27me3.r170316.txt

for name in `cat SampleID.H3K27me3.r170316.txt`
do
	quick_qsub.pl =M$name= { -pe shared 4 } $"macs2 callpeak -t ../BAMs/$name.H3K27me3.bam -c ../BAMs/$name.input.bam -g hs -B --nomodel --extsize 147 --SPMR --tempdir ./tmp -n $name.H3K27me3 --outdir $name"
done

for name in `cat SampleID.H3K27ac.r170316.txt`
do
	quick_qsub.pl =A$name= { -pe shared 4 } $"macs2 callpeak -t ../BAMs/$name.H3K27ac.bam -c ../BAMs/$name.input.bam -g hs -B --nomodel --extsize 147 --SPMR --tempdir ./tmp -n $name.H3K27ac --outdir $name"
done
