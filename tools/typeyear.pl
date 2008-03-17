#!/usr/bin/perl
#
# $Id$
#
# Author: Diomidis Spinellis (dds@aueb.gr)
#
# Split publications by year
#

# Associate the publication year with each publication

#$#ARGV == 0 || die "Usage: $0 file.bib <year>\n";
open(IN, $ARGV[0]) || die "Unable to open $ARGV[0]: $!\n";
print STDOUT "\\bibdata{macro,book,article,inproceedings,incollection,whitepaper,techreport,workingpaper}\n";
while (<IN>) {
	next if (/^\@string/i);
	if(/^\@\w+\s*\{(\w+)/) {
		endrecord() if (defined($key));
		$key = lc($1);
	} elsif (/^\s*year\s*\=\D*(\d+)/i) {
		print STDERR "Undefined key on line $.\n" unless (defined($key));
		print STDERR "Duplicate year on line $.\n" if (defined($year));
		$year = $1;
	}
}
endrecord();

sub
endrecord
{
	print STDERR "Undefined key on line $.\n" unless (defined($key));
	print STDERR "Undefined year on line $.\n" unless (defined($year));
	if ($ARGV[1] == $year) {
		print STDOUT "\\citation{$key}\n";
	}

	undef $key;
	undef $year;
}