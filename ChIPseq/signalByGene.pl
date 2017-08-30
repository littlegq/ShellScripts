#!/usr/bin/perl
use strict;
use warnings;
# The program adds the signal values by sample and by gene.

my $file = shift or die(
"Usage: $0 <Signal.file>\n
These columns of the signal file must be:
        1. Sample ID
        2. chrom
        3. start_pos
        4. end_pos
        5. region_id
        6. signal
        7. numLoci
        16. Gene
        19. FPKM of the gene\n");

my (%signal, %numRegion, %numLoci, %size, %fpkm);
open IN, $file or die($!);
while (<IN>) {
	chomp;
	if (/^SampleID/){
		print join "\t", 
			qw/SampleID Gene Signal numRegion numLoci Size maxFPKM/;
		print "\n";
		next;
	}
	my @a = split;
	next if $a[15] eq ".";
	my @genes = split /;/, $a[15];
	foreach my $g (@genes){
		my $k = join "\t", $a[0], $g;
		$signal{$k} += $a[5];
		$numRegion{$k} += 1;
		$numLoci{$k} += $a[6];
		$size{$k} += $a[3] - $a[2] + 1;
		$fpkm{$k} = $a[18];
	}
}
close IN;

foreach my $k (sort keys %signal){
	print join "\t", $k, $signal{$k}, $numRegion{$k}, $numLoci{$k}, $size{$k}, $fpkm{$k};
	print "\n";
}
