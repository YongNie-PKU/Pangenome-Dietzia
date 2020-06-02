#!/usr/bin/perl -w
use Math::Combinatorics;
use strict;
my $input=shift;
my $list = shift;
my $Usage="Discription:\n\tThis spript is disigned for statistics core genome distribution form groups.txt file generate by orthoMCL\nUsage:\n\tperl /data2/pxj2/TOOL/Tree/group_format.pl <groups.txt> <list_file>\n\tNOTE: The list_file contain the mark that used for distinguish each genome.\nCopyright:\n\tPeng Xiaojun  =>0,0<=!\n";
unless($input and $list){
	print STDERR $Usage;
	exit;
}
open FILE,$list;
my @cluster;
while(<FILE>){
	chomp;
	my @a = split;
	push(@cluster,$a[1]);
}
print "cluster";
foreach(@cluster){
	print "\t$_";
}
print "\n";
open FILE,$input;
my %state;
my %num;
while(<FILE>){
	my @a = split;
	my $h = shift @a;
	foreach my $a(@a){
		if($a=~/^(.*?)\|/){
			$state{$h}{$1}=1;
		}
		else{
			print STDERR "$a removed\n";
		}
		my $n = keys %{$state{$h}};
		$num{$h}=$n;
	}
}
my @h = keys %state;
for(my $i=1;$i<=@cluster;$i++){
	my $sum = 0;
	my $iter_number=0;
	my @temp;
	my @temp_h;
	my @n = combine($i,@cluster);
	foreach my $h(@h){
		if($num{$h}>=$i){
			push(@temp_h,$h);
		}
	}
	foreach my $c(@n){
		my $count=0;
		$iter_number++;
		LINE:foreach my $k1(@temp_h){
			foreach my $k2(@$c){
				unless($state{$k1}{$k2}){
					next LINE;
				}
			}
			$count++;
		}
		$sum+=$count;
		push(@temp,$count);
	}
	my $avg = $sum/$iter_number;
	my $str=0;
	foreach my $temp(@temp){
		$str+=($temp-$avg)**2;
	}
	$str=sqrt($str/$iter_number);
	print "$i\t$avg\t$str\n";
}
