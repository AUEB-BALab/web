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
	cat <<EOF >verify.aux
\bibstyle{html-u}
\bibdata{macro,$base}
\citation{*}
EOF
	if bibtex verify |
		egrep -v '^(This is BibTeX|The top-level auxiliary file|The style file|Database file)' |
		grep .		# Only errors make it here
	then
		exit 1
	fi
done
rm -f verify.blg verify.bbl verify.aux errors.txt
exit 0
