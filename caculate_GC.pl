#!/usr/bin/perl -w 
use strict;  
unless(@ARGV==2) {#@ARGV 
   die"Usage: perl $0 <input.fa> <out.gc>\n";
} 
my ($infile,$outfile) = @ARGV;
open IN,$infile || die"error: can't open infile: $infile";
open OUT,">$outfile" || die$!;
$/=">";<IN>;
while (<IN>) {
 my $id = $1 if(/^(\S+)/);
 chomp;
 s/^.+?\n//;
 s/\s//g;      
 my $GC = (tr/GC/GC/);
 my $AT = (tr/AT/AT/);
 my $len = $GC + $AT;
 my $gc_cont = $len ? $GC / $len : 0; 
 print OUT "$id\t$gc_cont\n"; 
 }
 $/="\n";
 close IN; 
 close OUT;