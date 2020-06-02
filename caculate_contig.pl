#!/usr/bin/perl
use strict;
use warnings;
use BeginPerlBioinfo;

print" please enter the filename :\n ";
my $filename=<STDIN>;
chomp $filename;

 my $No_contig=0;
 my $No_gene=0;
 my @GeneBankFile=();
 @GeneBankFile=get_file_data($filename);
 
foreach my $line(@GeneBankFile){
 if ( $line=~/^LOCUS/){
   ++$No_contig;
}elsif( $line=~/^     CDS/){
  ++$No_gene;
}

}

print"the number of contigs is :$No_contig\nthe number of genes is:$No_gene\n";
exit;
