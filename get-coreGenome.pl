#!/usr/bin/perl -w
use strict;
my $input=shift;
my $list = shift;
my $Usage="Discription:\n\tThis spript id disigned for geting core genome form groups.txt file generate by orthoMCL\nUsage:\n\tperl /data2/pxj2/TOOL/Tree/group_format.pl <groups.txt> <list_file>\n\tNOTE: The list_file contain the mark that used for distinguish each genome.\nCopyright:\n\tPeng Xiaojun  =>0,0<=!\n";
unless($input and $list){
	print STDERR $Usage;
	exit;
}
my %list_s;
open FILE,$list;
my @cluster;
while(<FILE>){
	chomp;
	my @a = split;
	push(@cluster,$a[1]);
	$list_s{$a[1]}=1;
}
open FILE,$input;
LINE:while(<FILE>){
	my @a = split;
	my $h = shift @a;
	my %temp_out;
	my %sing;
	foreach my $a(@a){
		if($a=~/^(.*?)\|/){
			unless($list_s{$1}){
				next;
			}
			if($sing{$1}){
				next LINE;
			}
			else{
				$sing{$1}=1;
				$temp_out{$a}=1;
			}
		}
		else{
			print STDERR "$a removed\n";
		}
	}
	my $s = 1;
	foreach my $c(@cluster){
		unless($sing{$c}){
			$s = 0;
		}
	}
	if($s==1){
		print "$h";
		foreach my $c(sort{$a cmp $b}keys %temp_out){
			print "\t$c";
		}
		print "\n";
	}
}
