#!/bin/sh
(
	echo -n "Total pages: "
	/usr/bin/find public_html -name '*.html' | wc -l
	for i in groups members projects
	do
		echo -n "$i: "
		/usr/bin/find "data/$i" -type f -name '*.xml' | wc -l
	done
	echo
	echo -n "Publications: "
	grep '@' data/publications/*.bib | wc -l
	for i in data/publications/*.bib
	do
		case $i in
		*article.bib) echo -n "Articles: " ;;
		*book.bib) echo -n "Books: " ;;
		*incollection.bib) echo -n "Book chapters: " ;;
		*inproceedings.bib) echo -n "Conference papers: " ;;
		*techreport.bib) echo -n "Technical reports: " ;;
		*workingpaper.bib) echo -n "Working papers: " ;;
		*whitepaper.bib) echo -n "White papers: " ;;
		esac
		grep '@' $i | wc -l
	done
	echo
	echo -n "Hyperlinks: "
	/usr/bin/find public_html -name '*.html' |
	xargs cat |
	perl -e 'while(<>){while(s/href//i){$x++}}print $x'
) |
awk -F: '
/^./{printf "%-20s %8d\n", toupper(substr($1, 1, 1)) substr($1, 2) ":", $2}
/^$/
'
