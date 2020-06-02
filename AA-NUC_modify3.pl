#!/usr/bin/perl -w
use strict;
use Bio::Tools::Run::Alignment::Clustalw;
use Bio::TreeIO;
# for projecting alignments from protein to R/DNA space
use Bio::Align::Utilities qw(aa_to_dna_aln);
# for input of the sequence data
use Bio::SeqIO;
use Bio::AlignIO;
 
my $aln_factory = Bio::Tools::Run::Alignment::Clustalw->new;
my $seqdata = shift || 'data.fa';
my $outfile = shift;
my $treesvg = shift;
my $seqio = new Bio::SeqIO(-file   => $seqdata,
                           -format => 'fasta');
my $outio = new Bio::SeqIO(-file   => ">$outfile",
						   -format => 'fasta');
my $treio = new Bio::TreeIO(-file  => ">$treesvg",
						    -format=> 'newick');
my %seqs;
my @prots;
# process each sequence
while ( my $seq = $seqio->next_seq ) {
    $seqs{$seq->display_id} = $seq;
    # translate them into protein
    my $protein = $seq->translate();
    my $pseq = $protein->seq();
    if( $pseq =~ /\*/ &&
        $pseq !~ /\*$/ ) {
          warn("provided a CDS sequence with a stop codon, PAML will choke!");
          exit(0);
    }
    # Tcoffee can't handle '*' even if it is trailing
    $pseq =~ s/\*//g;
    $protein->seq($pseq);
    push @prots, $protein;
}
 
if( @prots < 2 ) {
    warn("Need at least 2 CDS sequences to proceed");
    exit(0);
}
 

# Align the sequences with clustalw
my ($aa_aln,$tree_b) = $aln_factory->run(\@prots);
#my $aa_aln = $aln_factory->align(\@prots);
#my $tree_b = $aln_factory->tree($aa_aln);
$treio->write_tree($tree_b);
# project the protein alignment back to CDS coordinates
my $dna_aln = aa_to_dna_aln($aa_aln, \%seqs);
foreach my $seq($dna_aln->each_seq){
	$outio->write_seq($seq);
}

