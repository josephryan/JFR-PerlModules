package JFR::GFF3;

use strict;
use FileHandle;

# borrowed code from NHGRI::FastaParser & Bio::Tools::GFF;
$JFR::GFF3::AUTHOR  = 'Joseph Ryan'; 
$JFR::GFF3::VERSION = '0.01';

sub get_record {
    my $self = shift;
    return '' if (! $self->{'filehandle'} );

    my %h;
    my $seq  = '';
    my $line = '';

    my $fh = $ { $self->{'filehandle'} };

    while( $line = $fh->getline() ) {
        next if ($line =~ m/^#/);
        next if ($line =~ m/^\s*$/);
	chomp $line;
        my @fields = split /\t/, $line;
        die "not in gff format" unless (scalar(@fields) == 9);
        my $rh_att = _parse_attributes($fields[8]);
        return {'seqid' =>  $fields[0],
                'source' =>  $fields[1],
                'type' =>  $fields[2],
                'start' =>  $fields[3],
                'end' =>  $fields[4],
                'score' =>  $fields[5],
                'strand' =>  $fields[6],
                'phase' =>  $fields[7],
                'attributes' =>  $rh_att,
               };
    }
    undef $self->{'filehandle'};
}

# this routine will accept the 9th field of a GFF3 file and replace
# non-divisional semicolons with "INSERT_SEMICOLON_HERE"
# which later it returns to semicolons
# it also strips comments
sub _parse_attributes {
    my $str = shift;
    my $flag = 0;
    my %attributes = ();
    my @parsed = ();
    foreach my $att (split //, $str) {
        if ($att eq '"') { 
            $flag = ($flag == 0) ? 1:0;
        } elsif ($att eq ';' && $flag) {
            $att = 'INSERT_SEMICOLON_HERE';
        } elsif ($a eq '#' && !$flag) { 
            last;
        }
        push @parsed, $att;
    }
    my $rejoined = (join '', @parsed);
    foreach my $rj (split /;/, $rejoined) {
        $rj =~ s/INSERT_SEMICOLON_HERE/;/g;
        if ($rj =~ m/^([^=]+)\s*=\s*['"]?(\S+)['"]?/) {
            $attributes{$1} = $2;
        } else {
            %attributes = ();
            $attributes{'UNPARSED'} = $rejoined;
            last;
        }
    }
    return \%attributes;
}

sub new {
    my $invocant = shift;
    my $file     = shift;
    my $fh       = FileHandle->new($file, 'r');
    die "cannot open $file:$!" unless (defined $fh);
    my $class = ref($invocant) || $invocant;
    my $self = { 'filehandle'  => \$fh, };
    return bless $self, $class;
}

1;

__END__

# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

JFR::GFF3 - Perl extension for parsing GFF3 files. 

=head1 SYNOPSIS

  use JFR::GFF3

  my $gp = JFR::GFF3->new($gff3_file);

  while (my $rec = $gp->get_record()){
      print "$rec->{'seqid'}\n";
      print "$rec->{'source'}\n";
      print "$rec->{'type'}\n";
      print "$rec->{'start'}\n";
      print "$rec->{'end'}\n";
      print "$rec->{'score'}\n";
      print "$rec->{'strand'}\n";
      print "$rec->{'phase'}\n";

      # depending on how the ninth column looks 
      print "$rec->{'attributes'}->{'ID'}\n";
      print "$rec->{'attributes'}->{'Name'}\n";
      print "$rec->{'attributes'}->{'Parent'}\n";
  }

=head1 DESCRIPTION

For each line in a GFF3 file this module returns a hash with all the data
from that line.

=head1 AUTHOR

Joseph Ryan <josephryan@yahoo.com>
Some code from BIO::Tools:GFF and NHGRI::FataParser were used

=head1 SEE ALSO

L<JFR::Fasta> - parse Fasta files

L<JFR::Fastq> - parse Fastq files

L<JFR::Translate> - Translate DNA and RNA sequences

=cut
