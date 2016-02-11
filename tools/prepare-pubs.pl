#!/usr/bin/perl
#
# Replace [publicationtype] entries with the actual publications
# The replacement is performed in-line for the specified year
# Example:
# perl tools/prepare-pubs.pl 2015 public_html/reports/istlab-report-2009.html

sub get_pubs {
	my $flag = 0;
	my $li_found = 0;
	my $buf = "";

	open(my $HTML_PUB, '<', "build/$year-$_[0].html") || die "Unable to open build/$year-$_[0].html: $!\n";
	for (<$HTML_PUB>) {
		$flag = 1 if (m/<ul>/g);
		if (m/<\/ul>/g) {
			$buf .= '</ul>';
			$flag = 0;
		}
		$li_found = 1 if (m/<li>/g);
		$buf .= $_ if ($flag);
	}
	close($HTML_PUB);

	if ($li_found) { ; }

	return $li_found ? "$_[1] $buf" : $buf;
}

$year = $ARGV[0];

open(my $HTML, '<', $ARGV[1]) || die "Unable to open $ARGV[1] for input $!\n";

$output_buf = "";

for (<$HTML>) {
	if (m/\[book\]/g) {
		$output_buf .= get_pubs("book","<h2>Monographs and Edited Volumes</h2>");
	} elsif (m/\[article\]/g) {
		$output_buf .= get_pubs("article","<h2>Journal Articles</h2>");
	} elsif (m/\[incollection\]/g) {
		$output_buf .= get_pubs("incollection","<h2>Book Chapters</h2>");
	} elsif (m/\[inproceedings\]/g) {
		$output_buf .= get_pubs("inproceedings","<h2>Conference Publications</h2>");
	} elsif (m/\[techreport\]/g) {
		$output_buf .= get_pubs("techreport","<h2>Technical Reports</h2>");
	} elsif (m/\[whitepaper\]/g) {
		$output_buf .= get_pubs("whitepaper","<h2>White Papers</h2>");
	} elsif (m/\[workingpaper\]/g) {
		$output_buf .= get_pubs("workingpaper","<h2>Working Papers</h2>");
	} else {
		$output_buf .= $_;
	}
}

close($HTML);

open(my $HTML, '>', $ARGV[1]) || die "Unable to open $ARGV[1] for output: $!\n";
print $HTML $output_buf;
close($HTML);
