package JFR::Fastq;

# FASTQ SPEC SAYS BLOCK SHOULD BE: @<seqname>\n<seq>\n+[<seqname>]\n<qual>

use strict;
use FileHandle;
use IO::Uncompress::Gunzip qw($GunzipError);
use IO::Uncompress::Bunzip2 qw($Bunzip2Error);
use IO::Uncompress::Unzip qw($UnzipError);

$JFR::Fastq::AUTHOR  = 'Joseph Ryan';
$JFR::Fastq::VERSION = '0.05';

sub get_record{
    my $self = shift;
    my @record_lines = ();

    return '' if (! $self->{'filehandle'} );

    my %h;
    my $seq   = '';
    my $qual  = '';
    my $line  = '';

    my $fh = $ { $self->{'filehandle'} };

    while( $line = $fh->getline() ) {
	if ($line =~ m/^(\@.+)/ && $self->{'stored_pos'} != 3) {
	    $self->{'stored_pos'} = 1;
	    chomp $line;
            if ($seq) {
		$h{'def'}  = $self->{'stored_def'};
                $h{'seq'} = $seq;
                $h{'qual'} = $qual;
                $self->{'rec'} = \%h;
                $self->{'stored_def'} = $1;   
                return \%h;
	    }
	    $self->{'stored_def'} = $1;   
	} elsif ($self->{'stored_pos'} == 1) {
            $self->{'stored_pos'} = 2;
	    chomp $line;
            $seq .= $line;
        } elsif ($self->{'stored_pos'} == 2) {
            $self->{'stored_pos'} = 3;
        } elsif ($self->{'stored_pos'} == 3) {
            $self->{'stored_pos'} = 0;
	    chomp $line;
            $qual = $line;
        }
    }
    $h{'def'}  = $self->{'stored_def'};
    $h{'seq'} = $seq;
    $h{'qual'} = $qual;
    undef $self->{'filehandle'};
    $self->{'rec'} = \%h;
    return \%h;
}

sub print_record {
    my $self = shift;
    print "$self->{'rec'}->{'def'}\n$$self->{'rec'}->{'seq'}\n+\n$self->{'rec'}->{'qual'}";
}

sub new {
    my $invocant = shift;
    my $file     = shift;
    my $fh = '';


    if ($file =~ m/\.gz$/i) {
        $fh = IO::Uncompress::Gunzip->new($file)
            or die "IO::Uncompress::Gunzip of $file failed: $GunzipError\n";
    } elsif ($file =~ m/\.bz2$/i) {
        $fh = IO::Uncompress::Bunzip2->new($file)
            or die "IO::Uncompress::Bunzip2 of $file failed: $Bunzip2Error\n";
    } elsif ($file =~ m/\.zip$/i) {
        $fh = IO::Uncompress::Unzip->new($file)
            or die "IO::Uncompress::Unzip of $file failed: $UnzipError\n";
    } else {
        $fh = FileHandle->new($file,'r');
        die "cannot open $file: $!\n" unless(defined $fh);
    }
    my $class = ref($invocant) || $invocant;
    my $self = { 'filehandle'  => \$fh, 'stored_pos' => 0, 'stored_def' => '' };
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
      print "$rec->{'seq'}\n";
      print "+\n";
      print "$rec->{'qual'}\n";
      # or
      $fp->print_record();
  }

=head1 DESCRIPTION

For each record in a FASTQ file this module returns a hash that has the
defline and the sequence.

    $h->{'def'};
    $h->{'qual'};
    $h->{'seq'};

=head1 AUTHOR

Joseph Ryan <josephryan@yahoo.com>

=head1 SEE ALSO

L<JFR::Fasta> - parse FASTA files

L<JFR::GFF3> - parse GFF3 files

L<JFR::Translate> - Translate DNA and RNA sequences

=cut
