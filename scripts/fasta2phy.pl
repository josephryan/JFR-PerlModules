#!perl

our $VERSION = 0.05;
# version0.02 changes => made sure that data didn't start before col 12 
#                        to work with phylip
# version0.03 changes => change regex to allow a space immediately after
#                        '>' when creating ID
#                        $rec->{'defline'} =~ m/^>\s*(\S+)/;
#                        my $defline_abbreviation = $1;
# version 0.04 changes => works with JFR::Fasta instead of the old 
#                         NHGRI::FastaParser;
# version 0.05 changes => embedded POD documentation

use strict;
use warnings;
use JFR::Fasta;
use Data::Dumper;

MAIN: {
    my $file = $ARGV[0] || die "usage: $0 FASTA_FILE\n";
    my $rh_stats = check_file($file);
    if ($rh_stats->{'longest_def'} >= 11) {
        $rh_stats->{'longest_def'} += 2;
    } else {
        $rh_stats->{'longest_def'} = 11;
    }
    print "$rh_stats->{'num_seqs'}    $rh_stats->{'seq_len'}\n";
    my $fp = JFR::Fasta->new($file);
    while (my $rec = $fp->get_record()) {
        $rec->{'def'} =~ m/^>(\S+)/;
        print sprintf("%-$rh_stats->{'longest_def'}s", $1);
        print "$rec->{'seq'}\n";
    }
    print "\n"; # for good measure
}

sub check_file {
    my $file = shift;
    my %stats = ('longest_def' => 0, 'num_seqs' => 0, 'seq_len' => 0);
    my $fp = JFR::Fasta->new($file);
    while (my $rec = $fp->get_record()) {
        $stats{'num_seqs'}++;
        $rec->{'def'} =~ m/^>\s*(\S+)/;
        my $defline_abbreviation = $1;
        if (length($defline_abbreviation) > $stats{'longest_def'}) {
            $stats{'longest_def'} = length($defline_abbreviation);
        }
        if ($stats{'seq_len'}
            && (length($rec->{'seq'}) != $stats{'seq_len'})) {
            die "sequences must be same length: $rec->{'def'}\n";
        } else {
            $stats{'seq_len'} = length($rec->{'seq'});
        }
    }
    return \%stats;
}

__END__

=head1 NAME

B<fasta2phy.pl> - convert FASTA to PHYLIP format

=head1 AUTHOR

Joseph F. Ryan <joseph.ryan@whitney.ufl.edu>

=head1 SYNOPSIS

fasta2phy.pl FASTAFILE

=head1 

This script takes a FASTA file as an argument and prints a PHYLIP formatted version of the alignment.

=head1 BUGS

Please report them to any or all of the authors.

=head1 COPYRIGHT

Copyright (C) 2012,2013 Samuel H. Church, Joseph F. Ryan, Casey W. Dunn

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
