use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'JFR::Fasta',
    VERSION_FROM      => 'lib/JFR/Fasta.pm', # finds $VERSION
    LICENSE           => 'gpl_3',
    CONFIGURE_REQUIRES => { 'ExtUtils::MakeMaker' => '0', },
    TEST_REQUIRES => { 'Test::More' => '0', },
    EXE_FILES         => ['scripts/fasta2phy.pl',
                          'scripts/fasta2phylomatrix',
                          'scripts/get_seq_from_fasta.pl',
                          'scripts/replace_deflines.pl'],
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/JFR/Fasta.pm', # retrieve abstract from module
       AUTHOR         => q{Joseph F. Ryan <joseph.ryan@whitney.ufl.edu>}) : ()),
);

# Compatibility with old versions of ExtUtils::MakeMaker
unless (eval { ExtUtils::MakeMaker->VERSION('6.64'); 1 }) {
    my $test_requires = delete $WriteMakefileArgs{TEST_REQUIRES} || {};
    @{$WriteMakefileArgs{PREREQ_PM}}{keys %$test_requires} = values %$test_requires;
}

unless (eval { ExtUtils::MakeMaker->VERSION('6.55_03'); 1 }) {
    my $build_requires = delete $WriteMakefileArgs{BUILD_REQUIRES} || {};
    @{$WriteMakefileArgs{PREREQ_PM}}{keys %$build_requires} = values %$build_requires;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
    unless eval { ExtUtils::MakeMaker->VERSION('6.52'); 1 };
delete $WriteMakefileArgs{MIN_PERL_VERSION}
    unless eval { ExtUtils::MakeMaker->VERSION('6.48'); 1 };
delete $WriteMakefileArgs{LICENSE}
    unless eval { ExtUtils::MakeMaker->VERSION('6.31'); 1 };

WriteMakefile(%WriteMakefileArgs);
