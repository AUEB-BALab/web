#
# Eltrun web site creation and data validation
#
# (C) Copyright 2004 Diomidis Spinellis
#
# $Id$
#

MEMBERFILES=$(wildcard data/members/*.xml)
GROUPFILES=$(wildcard data/groups/*.xml)
PROJECTFILES=$(wildcard data/projects/*.xml)
SEMINARFILES=$(wildcard data/seminar/*.xml)
RELPAGEFILES=$(wildcard data/rel_pages/*.xml)
PUBFILE=build/pubs.xml
BIBFILES=$(wildcard data/publications/*.bib)

# BibTeX paths (used under Unix)
BIBINPUTS=data/publications:tools
BSTINPUTS=tools
export BIBINPUTS
export BSTINPUTS

# Database containing all the above
DB=build/db.xml
# XSLT file for public data
PXSLT=schema/eltrun-public.xslt
# XSLT file for fetching the ids
IDXSLT=schema/eltrun-ids.xslt
# Today' date in ISO format
TODAY=$(shell date +'%Y%m%d')
# Fetch the ids
GROUPIDS=$(shell xml tr ${IDXSLT} -s category=group ${DB})
PROJECTIDS=$(shell xml tr ${IDXSLT} -s category=project ${DB})
MEMBERIDS=$(shell xml tr ${IDXSLT} -s category=member ${DB})
RELPAGEIDS=$(shell xml tr ${IDXSLT} -s category=page ${DB})
# HTML output directory
HTML=public_html

ifdef MACHTYPE
# Unix
SSH=ssh
else
# Windows
SSH=plink
endif

all: html

$(DB): ${MEMBERFILES} ${GROUPFILES} ${PROJECTFILES} ${SEMINARFILES} ${RELPAGEFILES} $(BIBFILES) tools/makepub.pl
	@echo "Creating unified database"
	@echo '<?xml version="1.0"?>' > $@
	@echo '<eltrun>' >>$@ 
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
	@echo '<seminar_list>' >>$@
	@for file in $(SEMINARFILES); \
	do \
		grep -v -e "xml version=" $$file ; \
	done >>$@
	@echo '</seminar_list>' >> $@
	@echo '<page_list>' >> $@
	@for file in $(RELPAGEFILES); \
	do \
		grep -v -e "xml version=" $$file; \
	done >>$@
	@echo '</page_list>' >> $@
	@perl -n tools/makepub.pl $(BIBFILES) >>$@
	@echo '</eltrun>' >>$@

clean:
	-rm -f  build/* \
		${HTML}/groups/* \
		${HTML}/projects/* \
		${HTML}/members/* \
		${HTML}/seminar/* \
		${HTML}/rel_pages/* \
		${HTML}/publications/* 2>/dev/null

val: ${DB}
	@echo '---> Checking group data XML files ... '
	@-for file in $(GROUPFILES); \
	do \
		xml val -d schema/eltrun-group.dtd $$file; \
	done 
	@echo '---> Checking member data XML files ...'
	@-for file in $(MEMBERFILES); \
	do \
		xml val -d schema/eltrun-member.dtd $$file; \
	done
	@echo '---> Checking project data XML files ...'
	@-for file in $(PROJECTFILES); \
	do \
		xml val -d schema/eltrun-project.dtd $$file; \
	done
	@echo '---> Checking seminar data XML files ...'
	@-for file in $(SEMINARFILES); \
	do \
		xml val -d schema/eltrun-seminar.dtd $$file; \
	done
	@echo '---> Checking additional HTML pages'
	@-for file in $(RELPAGEFILES); \
	do \
		xml val -d schema/eltrun-page.dtd $$file; \
	done
	@echo '---> Checking db.xml ...'
	@xml val -d schema/eltrun.dtd $(DB)

html: ${DB}
# For all groups and the empty group
	@echo "Creating groups"
	@for group in $(GROUPIDS) ; \
	do \
		xml tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=group-details ${DB} >${HTML}/groups/$$group-details.html ; \
		xml tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=completed-projects ${DB} >${HTML}/groups/$$group-completed-projects.html ; \
		xml tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=current-projects ${DB} >${HTML}/groups/$$group-current-projects.html ; \
		xml tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=members ${DB} >${HTML}/groups/$$group-members.html ; \
		xml tr ${PXSLT} -s today=${TODAY} -s ogroup=$$group -s what=alumni ${DB} >${HTML}/groups/$$group-alumni.html ; \
		xml tr ${PXSLT} -s ogroup=$$group -s what=group-publications ${DB} >${HTML}/publications/$$group-publications.html ; \
	done
	@echo "Creating projects"
	@for project in $(PROJECTIDS) ; \
	do \
		xml tr ${PXSLT} -s oproject=$$project -s what=project-details ${DB} >${HTML}/projects/$$project.html ; \
		xml tr ${PXSLT} -s oproject=$$project -s what=project-publications ${DB} >${HTML}/publications/$$project-publications.html ; \
	done
	@echo "Creating members"
	@for member in $(MEMBERIDS) ; \
	do \
		xml tr ${PXSLT} -s omember=$$member -s what=member-details ${DB} >${HTML}/members/$$member.html ; \
		xml tr ${PXSLT} -s omember=$$member -s what=member-publications ${DB} >${HTML}/publications/$$member-publications.html ; \
	done
	@echo "Creating seminar list"
	@xml tr ${PXSLT} -s what=seminar ${DB} >${HTML}/seminar/index.html
	@echo "Creating additional HTML pages"
	@for page in $(RELPAGEIDS) ; \
	do \
		xml tr ${PXSLT} -s opage=$$page -s what=rel-pages ${DB} >${HTML}/rel_pages/$$page-page.html ; \
	done
	@echo "Creating publications"
	@$(SHELL) build/bibrun

dist: html
	$(SSH) istlab.dmst.aueb.gr "cd /home/dds/src/eltrun-web ; \
	umask 002 ; \
	cvs update -d ; \
	gmake ; \
	tar -C public_html -cf - . | tar -C /home/dds/web/istlab/eltrun -xvf -"

stats:
	@$(SHELL) tools/stats.sh
