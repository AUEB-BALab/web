#!/bin/perl
#
# Create a publication relation list in XML format
# By reading the corresponding bib files
# The following BibTeX extensions are processed:
# XEgroup: groups associated with the paper
# XEmember: members associated with the paper
# XEproject: projects associated with the paper
#
# (C) copyright 2004 Diomidis Spinellis
#
# $Id$
#

BEGIN {
	$/ = "@";
	open(RUN, ">build/bibrun") || die "$!\n";
	binmode(RUN);
	print RUN "(\n";
}

# Extract publication details
($type) = ($ARGV =~ m/^.*\/(\w+)\.bib$/);
($key) = ($_ =~ m/^\s*\w+\s*\{(\w+)/);
($group) = ($_ =~ m/XEgroup\s*\=\s*\"([^"]*)\"/i);
($project) = ($_ =~ m/XEproject\s*\=\s*\"([^"]*)\"/i);
($member) = ($_ =~ m/XEmember\s*\=\s*\"([^"]*)\"/i);
($year) = ($_ =~ m/year\s*\=\s*[\"\{]?([^\"\}\n]*)[\"\}\n]?/i);
# For documentation only
($title) = ($_ =~ m/title\s*\=\s*[\"\{]([^\"\}]*)[\"\}]/i);
($author) = ($_ =~ m/author\s*\=\s*[\"\{]([^\"\}]*)[\"\}]/i);
($author) = ($_ =~ m/editor\s*\=\s*[\"\{]([^\"\}]*)[\"\}]/i) unless (defined($author));

# Update citations associative array
foreach $id (split(/\s+/, $group)) {
	$citations{'group'}{$id}{$type} .= "\\citation{$key}\n";
	$citations{'group'}{$id}{'any'} .= "\\citation{$key}\n";
}
foreach $id (split(/\s+/, $project)) {
	$citations{'project'}{$id}{$type} .= "\\citation{$key}\n";
	$citations{'project'}{$id}{'any'} .= "\\citation{$key}\n";
}
foreach $id (split(/\s+/, $member)) {
	$citations{'member'}{$id}{$type} .= "\\citation{$key}\n";
	$citations{'member'}{$id}{'any'} .= "\\citation{$key}\n";
}

# Convert attribute contents to attribute definition
$group = "group=\"$group\"" if (defined($group));
$project = "project=\"$project\"" if (defined($project));
$member = "member=\"$member\"" if (defined($member));

$pubs .= qq{
	<publication id="$key" type="$type" $group $project $member>
		<pub_title>$title</pub_title>
		<pub_author>$author</pub_author>
		<pub_year>$year</pub_year>
	</publication>
} if (defined($type) && defined($key));


END {
	print "<publication_list>\n";
	print "$pubs";
	print "</publication_list>\n";
	print "<publication_type_list>\n";
	foreach $group (keys %citations) {
		foreach $id (keys %{$citations{$group}}) {
			print "\t<publication_type for=\"$id\">\n";
			foreach $type (sort keys %{$citations{$group}{$id}}) {
				print "\t\t<has_$type/>\n";
				$auxfile = "build/$id-$type.aux";
				open(OUT, ">$auxfile") || die "Unable to open $auxfile for writing: $!\n";
				print OUT '\bibdata{macro,magazine,book,article,inproceedings,incollection,whitepaper,techreport,workingpaper}';
				print OUT "\n$citations{$group}{$id}{$type}";
				close OUT;
 				print RUN qq{perl tools/bib2html $includepath -c -r -s empty $auxfile public_html/publications/${id}-publications.html\n} unless($type eq 'any');
			}
			print "\t</publication_type>\n";
		}
	}
	print "</publication_type_list>\n";
	print RUN q{ ) 2>&1 |
perl -n -e '
# Remove bib2html noise
	next if (/^Use of uninitialized/);
	next if (/^The /);
	next if (/^This is /);
	next if (/^Database /);
	print;
'
exit 0
};
}
