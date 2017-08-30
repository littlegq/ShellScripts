#!/bin/sh

window="1000"
step="500"

echo "#!/bin/sh" > qsub.sh
for name in `cat /net/isi-dcnl/ifs/user_data/jochan/Group/qgong/T.Methy/SampleID.txt` 
do
	awk '$3+$4>9' $name.pdr.cov | msort -k b1,n2 > $name.hicov.pdr
	cut -f1,2,3 $name.hicov.pdr > $name.tt1
	cut -f1,2,4 $name.hicov.pdr > $name.tt2
	cut -f1,2,5 $name.hicov.pdr > $name.tt3
	cut -f1,2,6 $name.hicov.pdr > $name.tt4
	depth_sliding.pl $name.tt1 /net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Sequence/WholeGenomeFasta/genome.fa.fai $window $step > $name.ttc1
	depth_sliding.pl $name.tt2 /net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Sequence/WholeGenomeFasta/genome.fa.fai $window $step > $name.ttc2
	depth_sliding.pl $name.tt3 /net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Sequence/WholeGenomeFasta/genome.fa.fai $window $step > $name.ttc3
	depth_sliding.pl $name.tt4 /net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Sequence/WholeGenomeFasta/genome.fa.fai $window $step > $name.ttc4
	paste $name.ttc1 $name.ttc2 $name.ttc3 $name.ttc4 | cut -f1,2,3,6,9,12 | awk '$3+$4>1' > $name.1kw500s.pdr
	rm $name.tt1 $name.tt2 $name.tt3 $name.tt4 $name.ttc1 $name.ttc2 $name.ttc3 $name.ttc4
	echo $name > $name.hicov.pdr.1
	cat $name.hicov.pdr >> $name.hicov.pdr.1
	AddSampleIDColumn.pl $name.hicov.pdr.1 > $name.hicov.pdr.txt
	rm $name.hicov.pdr.1
	echo $name > $name.1kw500s.pdr.1
	cat $name.1kw500s.pdr >> $name.1kw500s.pdr.1
	AddSampleIDColumn.pl $name.1kw500s.pdr.1 > $name.1kw500s.pdr.txt
	rm $name.1kw500s.pdr.1
done

