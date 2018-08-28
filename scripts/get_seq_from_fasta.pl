#!perl

use strict;
use warnings;
use JFR::Fasta;

# script to extract sequences based on a regex from a FASTA file
our $VERSION = 0.02;

MAIN: {
    my $file  =  $ARGV[0] || usage();
    my $regex =  $ARGV[1] || usage();
    my $coord1 = $ARGV[2];
    my $coord2 = $ARGV[3];

    my $fp = JFR::Fasta->new($file);
    while (my $rec = $fp->get_record()) {
        if ($rec->{'def'} =~ m/$regex/) {
            if ($coord1 && $coord2) {
                my $seq = substr $rec->{'seq'}, ($coord1 - 1), ($coord2 - $coord1 + 1);
                print "$rec->{'def'} $coord1-$coord2\n$seq\n";
            } else {
                print "$rec->{'def'}\n$rec->{'seq'}\n";
            }
        }
    }
}

sub usage {
    die "$0 FASTA REGEX [COORD1] [COORD2]\n";
}

__END__

=head1 NAME

B<get_seq_from_fasta.pl> - Extract seq(s) from FASTA file based on pattern in definition line

=head1 AUTHOR

Joseph Ryan <joseph.ryan@whitney.ufl.edu>

=head1 SYNOPSIS

get_seq_from_fasta.pl FASTA REGEX [COORD1] [COORD2]

=head1 BUGS

Please report them to the author.

=head1 COPYRIGHT

Copyright (C) 2018, Joseph Ryan

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut
