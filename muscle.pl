#!/usr/bin/perl -w
my $dir = shift;
#my $tag = shift;
#unless($tag){
#	$tag='fasta';
#}
my @file = glob "$dir/*";
my $head = shift @file;
foreach my $file(@file){
	$i++;
	$file=~/^$dir\/(.*)$/;
	my $tt=$1;
	system "muscle -in $file -out $tt.muscle.fasta &";
	if($i>=10){
		wait;
		$i--;
	}
}
$head=~/^$dir\/(.*)$/;
my $tt=$1;
sleep(10);
system "muscle -in $head -out $tt.muscle.fasta";
