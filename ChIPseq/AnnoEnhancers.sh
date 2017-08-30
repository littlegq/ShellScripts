#!/bin/sh

for name in `cat SampleID.enhancer.r170321.txt`
do
	grep -vE '\#|REGION_ID' $name"_AllEnhancers.table.txt" | reorder_columns.pl - 2-4,1,5- | sort -k1,1 -k2,2n > $name"_AllEnhancers.table.bed"
	bedtools intersect -loj  -a $name"_AllEnhancers.table.bed" -b aCD4.PirGeneLinks.bed > $name"_AllEnhancers.gene.txt"
	./AitlMaxFpkm.pl $name"_AllEnhancers.gene.txt" > $name"AllEnhancers.gene.exp.txt"
	./TopChicagoGenes.pl $name"AllEnhancers.gene.exp.txt" > $name"_AllEnhancers.TopGene.txt"
done


