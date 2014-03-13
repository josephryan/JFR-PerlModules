package JFR::FormatSeq;

use strict;

$JFR::FormatSeq::AUTHOR  = 'Joseph Ryan';
$JFR::FormatSeq::VERSION = '0.01';

sub format_seq {
    my $seq = shift;
    my $width = shift || 60;
    my $section = '';
    my $formatted = '';

    while (length($seq) > $width) {
        $section = substr($seq, 0, $width);
        $formatted .= "$section\n";
        $seq = substr($seq,$width);
    }
    $formatted .= $seq;
    return $formatted;
}

__END__

=head1 NAME

JFR::FormatSeq - Perl extension for formatting FASTA files. 

=head1 SYNOPSIS

  use JFR::FormatSeq;

  my $formatted_60 = JFR::FormatSeq::format_seq($seq);

  my $formatted_50 = JFR::FormatSeq::format_seq($seq,50);

=head1 DESCRIPTION


=head1 AUTHOR

Joseph Ryan <josephryan@yahoo.com>
originally by others at NHGRI

=head1 SEE ALSO

perl(1).

=cut
