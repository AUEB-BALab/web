#/usr/bin/perl
#
# Create a UMLGraph sequence diagram from the commit history
#
# (C) 2004 Diomidis Spinellis
#
# $Id$
#

open(OUT, '>build/seq.pic') || die;
binmode OUT;
print OUT ".PS\n";
print OUT "copy \"sequence.pic\";\n";
@commiters = `cvs history -p eltrun-web -a -c | awk "{print \$5}" | sort -u`;

for $c (@commiters) {
	chop $c;
	print OUT "object(C$c,\"$c\");\n";
}

print OUT "step();\n";
print OUT "spacing = .01\n";

open(IN,'cvs history -p eltrun-web -a -c | sort +1|');
while (<IN>) {
	print;
	($action, $d, $t, $o, $name, $ver, $file) = split;
	print OUT "active(C$name);\n";
	print OUT "step();\n";
	print OUT "inactive(C$name);\n";
}

for $c (@commiters) {
	print OUT "complete(C$c);\n";
}

print OUT ".PE\n";
