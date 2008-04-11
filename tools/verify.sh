#!/bin/sh
#
# Verify the integrity of the files used in this process
# Exit with 0 if ok 1 if an error was found
#
# $Id$
#

for i in data/publications/*.bib
do
	base=`basename $i .bib`
	echo Verifying $base
	echo \\Bibstyle\{html-n\} | tr "BC" "bc" > verify.aux
    echo \\Bibdata\{macro,$base\} | tr "BC" "bc" >> verify.aux
    echo \\Citation\{\*\} | tr "BC" "bc" >> verify.aux
	if bibtex $1 $2 $3 verify |
		egrep -v "^(This is BibTeX|The top-level auxiliary file|The style file|Database file)" |
		grep .		# Only errors make it here
	then
		exit 1
	fi
done
rm -f verify.blg verify.bbl verify.aux
exit 0
