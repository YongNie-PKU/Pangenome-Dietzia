#!/usr/bin/perl

use Bio::SeqIO;
use Getopt::Long;
use Bio::SeqFeatureI;
use Data::Dumper;

my $file = shift;

my $seqin = Bio::SeqIO->new(-file =>$file,-format=>'genbank');
while(my $seq=$seqin->next_seq()){
        my $seq_id = $seq->display_id();

        my @feats = $seq->get_all_SeqFeatures();
        for my $f (@feats){

                my $tag = $f->primary_tag();
                my $start = $f->start();
                my $end = $f->end();
                my $strand = $f->strand();
                my $tseq = $seq->subseq($start,$end);

                if ($tag eq "rRNA"){

                        my @tmp = $f->get_tag_values('product');
                        if ($tmp[0] =~ /16S/){
                                printf ">%s_%s_%s_%s\n",$seq_id,$start,$end,$strand;
                                print "$tseq\n";

                        }
                }
        }
}

