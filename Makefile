# ISTLab web site creation and data validation
#
# (C) Copyright 2004 Diomidis Spinellis
#
# $Id$
#

ifdef SYSTEMDRIVE
# Windows - CygWin
SSH=plink
PATHSEP=;
else
ifdef SystemDrive
# Windows - GNU Win32
SSH=plink
PATHSEP=;
else
# Unix
SSH=ssh
PATHSEP=:
endif
endif

MEMBERFILES=$(wildcard data/members/*.xml)
GROUPFILES=$(wildcard data/groups/*.xml)
PROJECTFILES=$(wildcard data/projects/*.xml)
RELPAGEFILES=$(wildcard data/rel_pages/*.xml)
PUBFILE=build/pubs.xml
BIBFILES=$(wildcard data/publications/*.bib)

# BibTeX paths (used under Unix)
BIBINPUTS=data/publications$(PATHSEP)tools
BSTINPUTS=tools
export BIBINPUTS
export BSTINPUTS

# Database containing all the above
DB=build/db.xml
# XSLT file for public data
PXSLT=schema/istlab-public.xslt
# XSLT file for fetching the ids
IDXSLT=schema/istlab-ids.xslt
# XSLT file for the phone catalog
PHONEXSLT=schema/istlab-phone-catalog.xslt
# XSLT file for the email list
EMAILXSLT=schema/istlab-email-list.xslt
# XSLT file for phd-students
STUDXSLT=schema/istlab-phd-list.xslt
# XSLT file for reports
REPORTXSLT=schema/istlab-report.xslt
REPIDXXSLT=schema/istlab-report-index.xslt
# XSLT file for brochure
BROCHXSLT=schema/istlab-brochure.xslt
# Today' date in ISO format
TODAY=$(shell date +'%Y%m%d')
# Fetch the ids
GROUPIDS=$(shell xml tr ${IDXSLT} -s category=group ${DB})
PROJECTIDS=$(shell xml tr ${IDXSLT} -s category=project ${DB})
MEMBERIDS=$(shell xml tr ${IDXSLT} -s category=member ${DB})
RELPAGEIDS=$(shell xml tr ${IDXSLT} -s category=page ${DB})
# HTML output directory
HTML=public_html
# yearly report
CURRENT_YEAR=$(shell date +'%Y')

all: html

$(DB): ${MEMBERFILES} ${GROUPFILES} ${PROJECTFILES} ${SEMINARFILES} ${RELPAGEFILES} $(BIBFILES) tools/makepub.pl
	@echo "Creating unified database"
	@echo '<?xml version="1.0"?>' > $@
	@echo '<istlab>' >>$@ 
	@echo '<group_list>' >>$@ 
	@for file in $(GROUPFILES); \
	do \
		grep -v -e "xml version=" $$file ; \
	done >>$@
	@echo '</group_list>' >>$@
	@echo '<member_list>' >>$@
	@for file in $(MEMBERFILES); \
	do \
		grep -v -e "xml version=" $$file ; \
	done >>$@
	@echo '</member_list>' >>$@
	@echo '<project_list>' >>$@
	@for file in $(PROJECTFILES); \
	do \
		grep -v -e "xml version=" $$file ; \
	done >>$@
	@echo '</project_list>' >>$@
	@echo '<page_list>' >> $@
	@for file in $(RELPAGEFILES); \
	do \
		grep -v -e "xml version=" $$file; \
	done >>$@
	@echo '</page_list>' >> $@
	@perl -n tools/makepub.pl $(BIBFILES) >>$@
	@echo '</istlab>' >>$@

clean:
	-rm -f  build/* \
		${HTML}/groups/* \
		${HTML}/projects/* \
		${HTML}/members/* \
		${HTML}/rel_pages/* \
		${HTML}/misc/* \
		${HTML}/reports/* \
		${HTML}/brochure/* \
		${HTML}/publications/* 2>/dev/null
	-rm -f public_html/images/colgraph.svg
	-rm -f *.aux
	-rm -f *.bbl
	-rm -f *.blg

phone: ${DB}
	@echo "Creating phone catalog"
	@xml tr ${PHONEXSLT} ${DB} > ${HTML}/misc/catalog.html

val: ${DB}
	@echo '---> Checking group data XML files ... '
	@-for file in $(GROUPFILES); \
	do \
		xml val -d schema/istlab-group.dtd $$file > /dev/null 2>xmlval.out; \
		if [ $$? != "0" ]; then cat xmlval.out; fi; \
		rm xmlval.out; \
	done 
	@echo '---> Checking member data XML files ...'
	@-for file in $(MEMBERFILES); \
	do \
		xml val -d schema/istlab-member.dtd $$file > /dev/null 2>xmlval.out; \
		if [ $$? != "0" ]; then cat xmlval.out; fi; \
		rm xmlval.out; \
	done
	@echo '---> Checking project data XML files ...'
	@-for file in $(PROJECTFILES); \
	do \
		xml val -d schema/istlab-project.dtd $$file > /dev/null 2>xmlval.out; \
		if [ $$? != "0" ]; then cat xmlval.out; fi; \
		rm xmlval.out; \
	done
	@echo '---> Checking additional HTML pages ...'
	@-for file in $(RELPAGEFILES); \
	do \
		xml val -d schema/istlab-page.dtd $$file > /dev/null 2>xmlval.out; \
		if [ $$? != "0" ]; then cat xmlval.out; fi; \
		rm xmlval.out; \
	done
	@echo '---> Checking db.xml ...'
	@xml val -d schema/istlab.dtd $(DB)

html: verify ${DB} groups projects members rel_pages publications phone email-lists phd-students report brochure

report: ${DB}
	@echo "Creating ISTLab reports"
	@year=2002 ; \
	while `test $$year -le $(CURRENT_YEAR)` ; \
	do \
		perl tools/typeyear.pl data/publications/article.bib $$year > build/$$year-article.aux ; \
		perl tools/typeyear.pl data/publications/book.bib $$year > build/$$year-book.aux ; \
		perl tools/typeyear.pl data/publications/incollection.bib $$year > build/$$year-incollection.aux ; \
		perl tools/typeyear.pl data/publications/inproceedings.bib $$year > build/$$year-inproceedings.aux ; \
		perl tools/typeyear.pl data/publications/techreport.bib $$year > build/$$year-techreport.aux ; \
		perl tools/typeyear.pl data/publications/whitepaper.bib $$year > build/$$year-whitepaper.aux ; \
		perl tools/typeyear.pl data/publications/workingpaper.bib $$year > build/$$year-workingpaper.aux ; \
		xml tr ${REPORTXSLT} -s year=$$year -s cyear=$(CURRENT_YEAR) ${DB} > ${HTML}/reports/istlab-report-$$year.html ; \
		perl tools/bib2html -c -r -s empty build/$$year-article.aux build/$$year-article.html ; \
		perl tools/bib2html -c -r -s empty build/$$year-book.aux build/$$year-book.html ; \
		perl tools/bib2html -c -r -s empty build/$$year-incollection.aux build/$$year-incollection.html ; \
		perl tools/bib2html -c -r -s empty build/$$year-inproceedings.aux build/$$year-inproceedings.html ; \
		perl tools/bib2html -c -r -s empty build/$$year-techreport.aux build/$$year-techreport.html ; \
		perl tools/bib2html -c -r -s empty build/$$year-whitepaper.aux build/$$year-whitepaper.html ; \
		perl tools/bib2html -c -r -s empty build/$$year-workingpaper.aux build/$$year-workingpaper.html ; \
		perl tools/prepare-pubs.pl $$year public_html/reports/istlab-report-$$year.html; \
		year=`expr $$year + 1`; \
	done ; \
	cd public_html/reports ; xml ls > ../../build/ls.xml ; cd ../.. ; \
	xml tr ${REPIDXXSLT} build/ls.xml > ${HTML}/reports/index.html

brochure: ${DB}
	@echo "Creating ISTLab brochure"
	@year=`expr $(CURRENT_YEAR) - 2` ; \
	years=" " ; \
	while `test $$year -le $(CURRENT_YEAR)` ; \
	do \
		years="$$years $$year" ; \
		year=`expr $$year + 1` ; \
	done ; \
	perl tools/typeyear.pl data/publications/article.bib $$years > build/brochure-article.aux ; \
	perl tools/typeyear.pl data/publications/book.bib $$years > build/brochure-book.aux ; \
	perl tools/typeyear.pl data/publications/incollection.bib $$years > build/brochure-incollection.aux ; \
	perl tools/typeyear.pl data/publications/inproceedings.bib $$years > build/brochure-inproceedings.aux ; \
	perl tools/typeyear.pl data/publications/techreport.bib $$years > build/brochure-techreport.aux ; \
	perl tools/typeyear.pl data/publications/whitepaper.bib $$years > build/brochure-whitepaper.aux ; \
	perl tools/typeyear.pl data/publications/workingpaper.bib $$years > build/brochure-workingpaper.aux ; \
	xml tr ${BROCHXSLT} -s today=`expr $(CURRENT_YEAR) - 2`0101 ${DB} > ${HTML}/brochure/istlab-brochure.html ; \
	perl tools/bib2html -c -r -s empty build/brochure-article.aux build/brochure-article.html ; \
	perl tools/bib2html -c -r -s empty build/brochure-book.aux build/brochure-book.html ; \
	perl tools/bib2html -c -r -s empty build/brochure-incollection.aux build/brochure-incollection.html ; \
	perl tools/bib2html -c -r -s empty build/brochure-inproceedings.aux build/brochure-inproceedings.html ; \
	perl tools/bib2html -c -r -s empty build/brochure-techreport.aux build/brochure-techreport.html ; \
	perl tools/bib2html -c -r -s empty build/brochure-whitepaper.aux build/brochure-whitepaper.html ; \
	perl tools/bib2html -c -r -s empty build/brochure-workingpaper.aux build/brochure-workingpaper.html ; \
	perl tools/prepare-pubs.pl brochure public_html/brochure/istlab-brochure.html

groups: ${DB}
	@echo "Creating groups"
	@for group in $(GROUPIDS) ; \
	do \
		xml tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=group-details ${DB} >${HTML}/groups/$$group-details.html ; \
		xml tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=completed-projects ${DB} >${HTML}/groups/$$group-completed-projects.html ; \
		xml tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=current-projects ${DB} >${HTML}/groups/$$group-current-projects.html ; \
		xml tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=members ${DB} >${HTML}/groups/$$group-members.html ; \
		xml tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=alumni ${DB} >${HTML}/groups/$$group-alumni.html ; \
		xml tr ${PXSLT} -s ogroup=$$group -s what=group-publications -s menu=off ${DB} >${HTML}/publications/$$group-publications.html ; \
	done

projects: ${DB}
	@echo "Creating projects"
	@for project in $(PROJECTIDS) ; \
	do \
		xml tr ${PXSLT} -s oproject=$$project -s what=project-details -s menu=off ${DB} >${HTML}/projects/$$project.html ; \
		xml tr ${PXSLT} -s oproject=$$project -s what=project-publications -s menu=off ${DB} >${HTML}/publications/$$project-publications.html ; \
	done

members: ${DB}
	@echo "Creating members"
	@for member in $(MEMBERIDS) ; \
	do \
		xml tr ${PXSLT} -s omember=$$member -s what=member-details -s menu=off ${DB} >${HTML}/members/$$member.html ; \
		xml tr ${PXSLT} -s omember=$$member -s what=member-publications -s menu=off ${DB} >${HTML}/publications/$$member-publications.html ; \
	done

rel_pages: ${DB}
	@echo "Creating additional HTML pages"
	@for page in $(RELPAGEIDS) ; \
	do \
		xml tr ${PXSLT} -s opage=$$page -s what=rel-pages ${DB} >${HTML}/rel_pages/$$page-page.html ; \
	done

publications: ${DB}
	@echo "Creating publications"
	@$(SHELL) build/bibrun

phd-students: ${DB}
	@echo "Creating PhD Students list"
	@xml tr ${STUDXSLT} -s completed=0 ${DB} > ${HTML}/misc/phd-students.html
	@echo "Creating Awarded PhD's list"
	@xml tr ${STUDXSLT} -s completed=1 ${DB} > ${HTML}/misc/awarded-phd-students.html

email-lists: ${DB}
	@echo "Creating email lists"
	@for group in $(GROUPIDS) ; \
	do \
		xml tr ${EMAILXSLT} -s ogroup=$$group -s what=members-all ${DB} > lists/$$group-all.txt ; \
		xml tr ${EMAILXSLT} -s ogroup=$$group -s what=members-phd ${DB} > lists/$$group-phd.txt ; \
		xml tr ${EMAILXSLT} -s ogroup=$$group -s what=members-alumni ${DB} > lists/$$group-alumni.txt ; \
		xml tr ${EMAILXSLT} -s ogroup=$$group -s what=members-gl ${DB} > lists/$$group-gl.txt ; \
	done

dist: html
	$(SSH) istlab.dmst.aueb.gr "cd /home/dds/src/istlab-web ; \
	umask 002 ; \
	cvs update -d ; \
	gmake clean html ; \
	tar -C $(HTML) -cf - . | tar -mU -C /home/dds/web/istlab/content -xf -"

stats:
	@$(SHELL) tools/stats.sh

colgraph: $(HTML)/images/colgraph.svg

$(HTML)/images/colgraph.svg: tools/colgraph.sh $(BIBFILES)
	$(SHELL) tools/colgraph.sh >build/colgraph.neato
	neato build/colgraph.neato -Tsvg -o$@

verify:
	sh tools/verify.sh
