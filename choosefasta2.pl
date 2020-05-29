#!/usr/bin/perl -w
use Bio::SeqIO;
my $input =shift;
my $fasta = shift;
my $out_dir = shift;
unless($input and $fasta and $out_dir){
	print STDERR "Usage: choosefasta.pl <list_file> <fasta_file> <out_dir>!\n";
	exit;
}
if(-e $out_dir){
	print STDERR "$out_dir have exist!\n";
	exit;
}
else{
	mkdir "$out_dir" or die "can't mkdir $out_dir!\n";
}
my $fa = Bio::SeqIO->new(-file=>$fasta,-foramt=>'fasta');
while(my $seq =$fa->next_seq){
	$hash{$seq->id}=$seq;
}
open FILE,$input;
while(<FILE>){
	chomp;
	my @a = split;
	my $head_name = shift @a;
	$head_name=~s/\:$//;
	my $out = Bio::SeqIO->new(-file=>">$out_dir/$head_name",-format=>'fasta');
	foreach my $a(@a){
		my @b = split /,/,$a;
		foreach my $b(@b){
		unless($hash{$b}){
			print STDERR "$b\n";
			exit;
		}
		$out->write_seq($hash{$b});
		}
	
	}
}
