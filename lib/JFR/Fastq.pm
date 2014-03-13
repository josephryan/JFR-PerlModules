package JFR::Fastq;

use strict;
use FileHandle;

$JFR::Fastq::AUTHOR  = 'Joseph Ryan';
$JFR::Fastq::VERSION = '0.01';

sub get_record{
    my $self = shift;
    my @record_lines = ();

    return '' if (! $self->{'filehandle'} );

    my %h;
    my $seq  = '';
    my $line = '';

    my $fh = $ { $self->{'filehandle'} };

    while( $line = $fh->getline() ) {
	if ($line =~ m/^(\@.+)/) {
	    chomp $line;
            if ($seq) {
		$h{'def'}  = $self->{'stored_def'};
                $h{'rest'} = $seq;
                $self->{'rec'} = \%h;
                $self->{'stored_def'} = $1;   
                return \%h;
	    }
	    $self->{'stored_def'} = $1;   
	}   else {
            $seq .= $line;
        }
    }
    $h{'def'}  = $self->{'stored_def'};
    $h{'rest'} = $seq;
    undef $self->{'filehandle'};
    $self->{'rec'} = \%h;
    return \%h;
}

sub print_record {
    my $self = shift;
    die "unexpected" unless ($self->{'rec'}->{'def'} && $self->{'rec'}->{'rest'});
    print "$self->{'rec'}->{'def'}\n$self->{'rec'}->{'rest'}";
}

sub new {
    my $invocant = shift;
    my $file     = shift;
    my $fh = FileHandle->new($file,'r');
    die "cannot open $file: $!\n" unless(defined $fh);
    my $class = ref($invocant) || $invocant;
    my $self = { 'filehandle'  => \$fh, 'stored_def' => '' };
    return bless $self, $class;
}

1;

__END__

=head1 NAME

JFR::Fastq - Perl extension for parsing FASTQ files. 

=head1 SYNOPSIS

  use JFR::Fastq;

  my $fp = JFR::Fastq->new($fastq_file);

  while (my $rec = $fp->get_record()) {
      print "$rec->{'def'}\n";
      print "$rec->{'rest'}\n";
      # or
      $fp->print_record();
  }

=head1 DESCRIPTION

For each record in a FASTQ file this module returns a hash that has the
defline and the sequence.

    $h->{'def'};
    $h->{'rest'};

=head1 AUTHOR

Joseph Ryan <josephryan@yahoo.com>

=head1 SEE ALSO

L<JFR::Fasta> - parse FASTA files

L<JFR::GFF3> - parse GFF3 files

L<JFR::Translate> - Translate DNA and RNA sequences

=cut
