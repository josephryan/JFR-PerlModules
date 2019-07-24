#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 5;

BEGIN {
    use_ok( 'JFR::Fasta' ) || print "Bail out!\n";
    use_ok( 'JFR::Fastq' ) || print "Bail out!\n";
    use_ok( 'JFR::FormatSeq' ) || print "Bail out!\n";
    use_ok( 'JFR::GFF3' ) || print "Bail out!\n";
    use_ok( 'JFR::Translate' ) || print "Bail out!\n";
}

diag( "Testing JFR::Fasta $JFR::Fasta::VERSION, Perl $], $^X" );
