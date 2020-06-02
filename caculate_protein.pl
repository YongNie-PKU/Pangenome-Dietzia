#!/usr/bin/perl
use strict;
use warnings;
use BeginPerlBioinfo;

print" please enter the filename :\n ";
my $filename=<STDIN>;
chomp $filename;

 my $No_contig=0;
 my $No_gene=0;
 my $No_defined=0;
 my @GeneBankFile=();
 @GeneBankFile=get_file_data($filename);
 
foreach my $line(@GeneBankFile){
 if ( $line=~/^                     \/product="hypothetical protein"/){
   ++$No_contig;
}elsif( $line=~/^     CDS/){
  ++$No_gene;
}

}
$No_defined=$No_gene-$No_contig;

print"the number of undefined proteins is :$No_contig\nthe number of defined protein is:$No_defined\n";
exit;
