#!/bin/sh


for name in "AITL-0172s"
do
	for grp in "treat_pileup" "FE" "control_lambda" 
	do
		input="$name/$name.H3K27ac""_$grp.bdg"
		output="TDF/$name.H3K27ac.$grp.tdf"
		java -XX:MaxHeapSize=8G -jar /net/isi-dcnl/ifs/user_data/jochan/Group/qgong/bin/IGVTools/igvtools.jar toTDF $input $output hg19
	done
done

for name in "AITL-0172s"
do
	for grp in "control_lambda" "treat_pileup" "FE"
	do
		input="$name/$name.H3K27me3""_$grp.bdg"
		output="TDF/$name.H3K27me3.$grp.tdf"
		java -XX:MaxHeapSize=8G -jar /net/isi-dcnl/ifs/user_data/jochan/Group/qgong/bin/IGVTools/igvtools.jar toTDF $input $output hg19
	done
done
