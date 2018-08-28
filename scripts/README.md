# Scripts that use JFR-PerlModules

#### fasta2phy.pl

    uses JFR::Fasta to convert FASTA files to PHYLIP format

#### get_seq_from_fasta.pl

    uses JFR::Fasta to extract FASTA sequences with a pattern in defline

#### fasta2phylomatrix  

    uses JFR::fasta to concatenate multiple sequence alignments into a single
    "concatenated" matrix

#### replace_deflines.pl

    convert deflines to enumerated names

#### INSTALL

    from the parent directory run 
    ```perl Makefile.PL
    make
    make install```

    script will be installed automatically

#### Documentation

    Documentation is embedded in the script.  Run `perldoc SCRIPTNAME`

#### Copyright and License

Copyright (C) 2017 Joseph F. Ryan

The contents of this repository are free: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program in the file LICENSE. If not, see http://www.gnu.org/licenses/.


