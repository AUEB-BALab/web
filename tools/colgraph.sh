#!/bin/sh
#
# Create an AT&T Graphviz neato undirected graph from the
# publication collaboration data
#
# Diomidis Spinellis, April 2004
#
# $Id$
#

# Graph parameters
echo 'graph G {
	overlap=scale;
	epsilon=0.001;
	node [fontsize=12,fontname="Helvetica"];
'
# Generate the edges
grep -i '^[ 	]XEmember' data/publications/*.bib |
sed -n 's/.*=[ ]*"//
s/"[ ]*,$//
s/m_//g
s/\./_/g
s/  */ -- /gp' |
sed 's/$/;/'
# Generate the nodes with their URLs
grep -i '^[ 	]XEmember' data/publications/*.bib |
sed -n 's/.*=[ ]*"//
s/"[ ]*,$//
s/m_//g
s/\./_/g
s/  */\
/gp' |
/usr/bin/sort -u |
sed 's/\(.*\)/\1 [URL="..\/members\/m_\1.html"];/'
echo '}'
