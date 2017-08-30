#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

my $file = shift or die("Usage: $0 [-m] <*.compare.bed (from bedtools intersect>\n");

my %options=();
getopt('m', \%options);

my ( %tda, %cda, %gsize );
open IN, $file or die($!);
while (<IN>) {
    chomp;
    my @a    = split;
    my $size = $a[2] - $a[1];
    $gsize{ $a[3] } += $size;
    $tda{ $a[3] }   += $a[4] * $size;
    $cda{ $a[3] }   += $a[9] * $size;
}
close IN;

my @dr;
foreach my $k ( sort keys %gsize ) {
    my $dratio = sprintf( "%.3f", $tda{$k} / $cda{$k} );
    push @dr, $dratio;
    print join "\t", $k, $gsize{$k}, int( $cda{$k} ), int( $tda{$k} ), $dratio;
    print "\n";
}

my $MedRatio = sprintf( "%.2f", &median(@dr) );
if (defined $options{m} or $file =~ /H3K27me3/){
	print "#Promoter H3K27me3 density ratio: $MedRatio;\t";
	if($MedRatio <= 0.25){print "Passed\n";}else{print "Failed\n";}
}else{
	print "#Promoter H3K27ac density ratio: $MedRatio;\t";
	if($MedRatio >= 4){print "Passed\n";}else{print "Failed\n";}
}

sub median {
    my @vals = sort { $a <=> $b } @_;
    my $len = @vals;
    if ( $len % 2 ) {    # odd?
        return $vals[ int( $len / 2 ) ];
    }
    else {               #even
        return ( $vals[ int( $len / 2 ) - 1 ] + $vals[ int( $len / 2 ) ] ) / 2;
    }
}

