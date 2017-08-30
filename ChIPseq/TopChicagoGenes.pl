#!/usr/bin/perl
use strict;
use warnings;

# Used by AnnoEnhancers.sh

# Output single links for each listed enhancer regions
# For enhancer regions with no linked genes, listed "-1" etc as the original bedtools intersect output
# For enhancer regions with >=1 linked genes, listed the expressing one (FPKM>=1) with highest CHiCAGO scores 
# as caculated by Javierre et al, Cell 2016; if all linked genes' FPKM < 1, listed the one with highest score
# 
# Note: the input file must be sorted.

my $file = shift or die("Usage: $0 <*AllEnhancers.gene.exp.txt>\n");

my $maxc = -2;
my $cont = join "\t",
	qw/CHROM START STOP REGION_ID NUM_LOCI CONSTITUENT_SIZE H3K27ac_Signal Input_Signal	
	enhancerRank isSuper PIR_CHROM PIR_START PIR_STOP Gene CHiCAGO_score PIR_distance Max_AITL_FPKM/;
my $reg0 = 0;

open IN, $file or die($!);
while (<IN>) {
	chomp;
	my @a = split;
	my $reg1 = join "\t", @a[0..2];
	if($reg1 eq $reg0){
		if(@a > 16){
			$a[14] = $a[14] / 10000 if $a[16] < 1;
		}
		if($a[14] > $maxc){
			$maxc = $a[14];
			$cont = $_;
		}
	}else{
		print "$cont\n";
		$maxc = $a[14];
		$reg0 = $reg1;
		$cont = $_;
	}
}
close IN;

