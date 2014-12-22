# ISTLab web site creation and data validation
#
# (C) Copyright 2004 Diomidis Spinellis
#
# $Id$
#

ifdef SYSTEMDRIVE
# Windows - CygWin
SSH=ssh
PATHSEP=;
BIBTEX_OPTIONS=-W
SH=$(SHELL)
else
ifdef SystemDrive
# Windows - GNU Win32
SSH=plink
BIBTEX_OPTIONS=-W
PATHSEP=;
SH=$(SHELL)
else
# Unix
SSH=ssh
PATHSEP=:
SH=bash
endif
endif

# Name of XMLStarlet
XML=$(shell xmlstarlet --version 2>/dev/null 1>&2 && echo xmlstarlet || echo xml)

# HTML output directory
HTML=public_html

# Build directory
BUILD=build

BIBINPUTS=data/publications$(PATHSEP).$(PATHSEP)./tools

MEMBERFILES=$(wildcard data/members/*.xml)
GROUPFILES=$(wildcard data/groups/*.xml)
PROJECTFILES=$(wildcard data/projects/*.xml)
RELPAGEFILES=$(wildcard data/rel_pages/*.xml)
ANNOUNCEFILES=$(wildcard data/announce/*.xml)
PUBFILE=$(BUILD)/pubs.xml
BIBFILES=$(wildcard data/publications/*.bib)

# BibTeX paths (used under Unix)
BIBINPUTS=data/publications$(PATHSEP)tools$(PATHSEP).
BSTINPUTS=tools
export BIBINPUTS
export BSTINPUTS

# Database containing all the above
DB=$(BUILD)/db.xml
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
GROUPIDS=$(shell ${XML} tr ${IDXSLT} -s category=group ${DB})
PROJECTIDS=$(shell ${XML} tr ${IDXSLT} -s category=project ${DB})
MEMBERIDS=$(shell ${XML} tr ${IDXSLT} -s category=member ${DB})
RELPAGEIDS=$(shell ${XML} tr ${IDXSLT} -s category=page ${DB})
# yearly report
CURRENT_YEAR=$(shell date +'%Y')

all: html

prepare:
	@echo "Creating output directories"
	@if [ ! -d $(HTML) ]; then mkdir $(HTML); fi
	@if [ ! -d $(BUILD) ]; then mkdir $(BUILD); fi

$(DB): prepare ${MEMBERFILES} ${GROUPFILES} ${PROJECTFILES} ${SEMINARFILES} ${RELPAGEFILES} $(BIBFILES) tools/makepub.pl
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
	@echo '<announce_list>' >> $@
	@for file in $(ANNOUNCEFILES); \
	do \
		grep -v -e "xml version=" $$file; \
	done >> $@
	@echo "</announce_list>" >> $@
	@perl -n tools/makepub.pl $(BIBFILES) >> $@
	@echo '</istlab>' >> $@

clean:
	@rm -f  $(BUILD)/* \
		${HTML}/groups/* \
		${HTML}/projects/* \
		${HTML}/members/* \
		${HTML}/rel_pages/* \
		${HTML}/misc/* \
		${HTML}/reports/* \
		${HTML}/brochure/* \
		${HTML}/announce/* \
		${HTML}/publications/* 2>/dev/null
	@rm -f lists/* 2>/dev/null
	@rm -f public_html/images/colgraph.svg
	@rm -f *.aux *.bbl *.blg

phone: ${DB}
	@echo "Creating phone catalog"
	@${XML} tr ${PHONEXSLT} ${DB} > ${HTML}/misc/catalog.html

val: ${DB}
	@echo '---> Checking group data XML files ... '
	@-for file in $(GROUPFILES); \
	do \
		${XML} val -d schema/istlab-group.dtd $$file > /dev/null 2>xmlval.out; \
		if [ $$? != "0" ]; then cat xmlval.out; fi; \
		rm xmlval.out; \
	done 
	@echo '---> Checking member data XML files ...'
	@-for file in $(MEMBERFILES); \
	do \
		${XML} val -d schema/istlab-member.dtd $$file > /dev/null 2>xmlval.out; \
		if [ $$? != "0" ]; then cat xmlval.out; fi; \
		rm xmlval.out; \
	done
	@echo '---> Checking project data XML files ...'
	@-for file in $(PROJECTFILES); \
	do \
		${XML} val -d schema/istlab-project.dtd $$file > /dev/null 2>xmlval.out; \
		if [ $$? != "0" ]; then cat xmlval.out; fi; \
		rm xmlval.out; \
	done
	@echo '---> Checking additional HTML pages ...'
	@-for file in $(RELPAGEFILES); \
	do \
		${XML} val -d schema/istlab-page.dtd $$file > /dev/null 2>xmlval.out; \
		if [ $$? != "0" ]; then cat xmlval.out; fi; \
		rm xmlval.out; \
	done
	@echo '---> Checking announcements ...'
	@-for file in $(ANNOUNCEFILES); \
	do \
		${XML} val -d schema/istlab-announce.dtd $$file > /dev/null 2>xmlval.out; \
		if [ $$? != "0" ]; then cat xmlval.out; fi; \
		rm xmlval.out; \
	done
	@echo '---> Checking db.xml ...'
	@${XML} val -e -d schema/istlab.dtd $(DB)

html: verify ${DB} groups projects members rel_pages announcements publications phone email-lists phd-students report brochure

report: ${DB}
	@echo "Creating ISTLab reports"
	@year=2002 ; \
	while [ $$year -le $(CURRENT_YEAR) ] ; \
	do \
		perl tools/typeyear.pl data/publications/article.bib $$year > $(BUILD)/$$year-article.aux 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/typeyear.pl data/publications/book.bib $$year > $(BUILD)/$$year-book.aux 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/typeyear.pl data/publications/incollection.bib $$year > $(BUILD)/$$year-incollection.aux 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/typeyear.pl data/publications/inproceedings.bib $$year > $(BUILD)/$$year-inproceedings.aux 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/typeyear.pl data/publications/techreport.bib $$year > $(BUILD)/$$year-techreport.aux 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/typeyear.pl data/publications/whitepaper.bib $$year > $(BUILD)/$$year-whitepaper.aux 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/typeyear.pl data/publications/workingpaper.bib $$year > $(BUILD)/$$year-workingpaper.aux 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		${XML} tr ${REPORTXSLT} -s year=$$year -s cyear=$(CURRENT_YEAR) ${DB} > ${HTML}/reports/istlab-report-$$year.html 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/$$year-article.aux $(BUILD)/$$year-article.html 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/$$year-book.aux $(BUILD)/$$year-book.html 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/$$year-incollection.aux $(BUILD)/$$year-incollection.html 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/$$year-inproceedings.aux $(BUILD)/$$year-inproceedings.html 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/$$year-techreport.aux $(BUILD)/$$year-techreport.html 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/$$year-whitepaper.aux $(BUILD)/$$year-whitepaper.html 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/$$year-workingpaper.aux $(BUILD)/$$year-workingpaper.html 2>bibval.out; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		perl tools/prepare-pubs.pl $$year public_html/reports/istlab-report-$$year.html 2>bibval.out ; \
		if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
		year=`expr $$year + 1`; \
	done ; \
	cd public_html/reports ; ${XML} ls > ../../$(BUILD)/ls.xml ; cd ../.. ; \
	${XML} tr ${REPIDXXSLT} $(BUILD)/ls.xml > ${HTML}/reports/index.html

brochure: ${DB}
	@echo "Creating ISTLab brochure"
	@year=`expr $(CURRENT_YEAR) - 2` ; \
	years=" " ; \
	while [ $$year -le $(CURRENT_YEAR) ] ; \
	do \
		years="$$years $$year" ; \
		year=`expr $$year + 1` ; \
	done ; \
	perl tools/typeyear.pl data/publications/article.bib $$years > $(BUILD)/brochure-article.aux 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/typeyear.pl data/publications/book.bib $$years > $(BUILD)/brochure-book.aux 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/typeyear.pl data/publications/incollection.bib $$years > $(BUILD)/brochure-incollection.aux 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/typeyear.pl data/publications/inproceedings.bib $$years > $(BUILD)/brochure-inproceedings.aux 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/typeyear.pl data/publications/techreport.bib $$years > $(BUILD)/brochure-techreport.aux 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/typeyear.pl data/publications/whitepaper.bib $$years > $(BUILD)/brochure-whitepaper.aux 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/typeyear.pl data/publications/workingpaper.bib $$years > $(BUILD)/brochure-workingpaper.aux 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	${XML} tr ${BROCHXSLT} -s today=`expr $(CURRENT_YEAR) - 2`0101 ${DB} > ${HTML}/brochure/istlab-brochure.html 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/brochure-article.aux $(BUILD)/brochure-article.html 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/brochure-book.aux $(BUILD)/brochure-book.html 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/brochure-incollection.aux $(BUILD)/brochure-incollection.html 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/brochure-inproceedings.aux $(BUILD)/brochure-inproceedings.html 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/brochure-techreport.aux $(BUILD)/brochure-techreport.html 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/brochure-whitepaper.aux $(BUILD)/brochure-whitepaper.html 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/bib2xhtml -c -r -b "$(BIBTEX_OPTIONS)" -s empty $(BUILD)/brochure-workingpaper.aux $(BUILD)/brochure-workingpaper.html 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \
	perl tools/prepare-pubs.pl brochure public_html/brochure/istlab-brochure.html 2>bibval.out ; \
	if [ $$? != "0" ] ; then cat bibval.out; fi; rm bibval.out ; \

groups: ${DB}
	@echo "Creating groups"
	@for group in $(GROUPIDS) ; \
	do \
		${XML} tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=group-details ${DB} >${HTML}/groups/$$group-details.html ; \
		${XML} tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=completed-projects ${DB} >${HTML}/groups/$$group-completed-projects.html ; \
		${XML} tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=current-projects ${DB} >${HTML}/groups/$$group-current-projects.html ; \
		${XML} tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=members ${DB} >${HTML}/groups/$$group-members.html ; \
		${XML} tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=alumni ${DB} >${HTML}/groups/$$group-alumni.html ; \
		${XML} tr ${PXSLT} -s ogroup=$$group -s what=group-publications -s menu=off ${DB} >${HTML}/publications/$$group-publications.html ; \
	done

projects: ${DB}
	@echo "Creating projects"
	@for project in $(PROJECTIDS) ; \
	do \
		${XML} tr ${PXSLT} -s oproject=$$project -s what=project-details -s menu=off ${DB} >${HTML}/projects/$$project.html ; \
		${XML} tr ${PXSLT} -s oproject=$$project -s what=project-publications -s menu=off ${DB} >${HTML}/publications/$$project-publications.html ; \
	done

members: ${DB}
	@echo "Creating members"
	@for member in $(MEMBERIDS) ; \
	do \
		${XML} tr ${PXSLT} -s omember=$$member -s what=member-details -s menu=off ${DB} >${HTML}/members/$$member.html ; \
		${XML} tr ${PXSLT} -s omember=$$member -s what=member-publications -s menu=off ${DB} >${HTML}/publications/$$member-publications.html ; \
	done

rel_pages: ${DB}
	@echo "Creating additional HTML pages"
	@for page in $(RELPAGEIDS) ; \
	do \
		${XML} tr ${PXSLT} -s opage=$$page -s what=rel-pages ${DB} >${HTML}/rel_pages/$$page-page.html ; \
	done

announcements: ${DB}
	@echo "Creating announcements"
	@${XML} tr ${PXSLT} -s ogroup=g_istlab -s what=announce ${DB} >${HTML}/announce/announcements.html

publications: ${DB}
	@echo "Creating publications"
	@$(SH) $(BUILD)/bibrun

phd-students: ${DB}
	@echo "Creating PhD Students list"
	@${XML} tr ${STUDXSLT} -s completed=0 ${DB} > ${HTML}/misc/phd-students.html
	@echo "Creating Awarded PhD's list"
	@${XML} tr ${STUDXSLT} -s completed=1 ${DB} > ${HTML}/misc/awarded-phd-students.html

email-lists: ${DB}
	@echo "Creating email lists"
	@mkdir -p lists
	@for group in $(GROUPIDS) ; \
	do \
		${XML} tr ${EMAILXSLT} -s ogroup=$$group -s what=members-all ${DB} > lists/$$group-all.txt ; \
		${XML} tr ${EMAILXSLT} -s ogroup=$$group -s what=members-phd ${DB} > lists/$$group-phd.txt ; \
		${XML} tr ${EMAILXSLT} -s ogroup=$$group -s what=members-alumni ${DB} > lists/$$group-alumni.txt ; \
		${XML} tr ${EMAILXSLT} -s ogroup=$$group -s what=members-gl ${DB} > lists/$$group-gl.txt ; \
	done

stats:
	@$(SH) tools/stats.sh

colgraph: $(HTML)/images/colgraph.svg

$(HTML)/images/colgraph.svg: tools/colgraph.sh $(BIBFILES)
	$(SH) tools/colgraph.sh >$(BUILD)/colgraph.neato
	neato $(BUILD)/colgraph.neato -Tsvg -o$@

verify:
	$(SHELL) tools/verify.sh $(BIBTEX_OPTIONS)
