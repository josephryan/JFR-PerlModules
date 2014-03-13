package JFR::Translate;

use strict;
$JFR::Translate::AUTHOR  = 'Joseph Ryan';
$JFR::Translate::VERSION = '0.01';

our %TRANSLATION = (
          'UUU' => 'F', 'UUC' => 'F', 'UUA' => 'L', 'UUG' => 'L', 'UUN' => 'X',
          'UCU' => 'S', 'UCC' => 'S', 'UCA' => 'S', 'UCG' => 'S', 'UCN' => 'S',
          'UAU' => 'Y', 'UAC' => 'Y', 'UAA' => '*', 'UAG' => '*', 'UAN' => 'X',
          'UGU' => 'C', 'UGC' => 'C', 'UGA' => '*', 'UGG' => 'W', 'UGN' => 'X',
          'CUU' => 'L', 'CUC' => 'L', 'CUA' => 'L', 'CUG' => 'L', 'CUN' => 'L',
          'CCU' => 'P', 'CCC' => 'P', 'CCA' => 'P', 'CCG' => 'P', 'CCN' => 'P',
          'CAU' => 'H', 'CAC' => 'H', 'CAA' => 'Q', 'CAG' => 'Q', 'CAN' => 'X',
          'CGU' => 'R', 'CGC' => 'R', 'CGA' => 'R', 'CGG' => 'R', 'CGN' => 'R',
          'AUU' => 'I', 'AUC' => 'I', 'AUA' => 'I', 'AUG' => 'M', 'AUN' => 'X',
          'ACU' => 'T', 'ACC' => 'T', 'ACA' => 'T', 'ACG' => 'T', 'ACN' => 'T',
          'AAU' => 'N', 'AAC' => 'N', 'AAA' => 'K', 'AAG' => 'K', 'AAN' => 'X',
          'AGU' => 'S', 'AGC' => 'S', 'AGA' => 'R', 'AGG' => 'R', 'AGN' => 'X',
          'GUU' => 'V', 'GUC' => 'V', 'GUA' => 'V', 'GUG' => 'V', 'GUN' => 'V',
          'GCU' => 'A', 'GCC' => 'A', 'GCA' => 'A', 'GCG' => 'A', 'GCN' => 'A',
          'GAU' => 'D', 'GAC' => 'D', 'GAA' => 'E', 'GAG' => 'E', 'GAN' => 'X',
          'GGU' => 'G', 'GGC' => 'G', 'GGA' => 'G', 'GGG' => 'G', 'GGN' => 'G',
         );

sub translate {
    my $seq   = shift;
    my $frame = shift || 1;
    my $translated = "";
 
    $seq =~ s/[tT]/U/g if ($seq =~ /[tT]/);
    unless ($frame != 0 && $frame <= 3 && $frame >= -3) {
        warn "warning: frame must be either 1,2,3,-1,-2,-3 not $frame";
        return '';
    }    
    if ($frame < 0) {
        $seq = revcomp($seq);    # reverse sequence
        $frame = $frame * -1;    # set to positive frame
    } 
    $seq = substr($seq,($frame - 1));
    $seq =~ tr/a-z/A-Z/;
    for(my $len=length($seq),my $i=0; $i<($len-2) ; $i+=3) {
        $translated .= $TRANSLATION{substr($seq,$i,3)} || 'X';
    }
    return $translated;
}

sub revcomp {
    my $seq = shift;
    $seq = reverse($seq);
    $seq =~ tr/acgturymkswhbvdACGTURYMKSWHBVD/ugcaayrkmswdvbhUGCAAYRKMSWDVBH/;
    return $seq;
}

__END__

=head1 NAME

JFR::Translate - Perl extension for Translating DNA and RNA sequences

=head1 SYNOPSIS

  use JFR::Translate;

  my $seq = 'ACGTUCAACGTU';   # you can use either T or U or both

  foreach my $frame (1, 2, 3, -1, -2, -3) {
      my $tr_seq = JFR::Translate::translate($seq);
  }

=head1 DESCRIPTION

Simple module to translate DNA and RNA sequences.  It automatically does
a revcomp for translate of negative frames.

=head1 AUTHOR

Joseph Ryan <josephryan@yahoo.com>

Some code originated from NHGRI Scientific Programming Core

=head1 SEE ALSO

L<JFR::GFF3> - parse GFF3 files

L<JFR::Fasta> - Parse FASTA files


=cut
