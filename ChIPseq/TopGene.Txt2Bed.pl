#!/usr/bin/perl
use strict;
use warnings;

# Used by AnnoEnhancers.sh


my $file = shift or die("Usage: $0 <*_AllEnhancers.TopGene.txt>\n");
open IN, $file or die($!);
while (<IN>) {
	chomp;
	next if /^CHROM/;
	my @a = split;
	my $name = $a[3];
	$name = $a[13] unless $a[13] eq ".";
	my $score = 0;
	$score = $a[6] - $a[7] if $a[6] > $a[7];
	print join "\t", @a[0..2], $name, $score, ".", "$a[9]\n";
}
close IN;

	
