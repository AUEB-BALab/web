#!/usr/bin/perl

# amateurish but working ... need to catch that deadline :)

sub get_pubs {
	$flag = 0;
	$li_found = 0;
	$buf = "";
	
	open(HTML_PUB, "build/$year-$_[0].html");
	for (<HTML_PUB>) {
		if(m/<ul>/g) {
			$flag = 1;
		}
		if(m/<\/ul>/g) {
			$buf .= '</ul>';
			$flag = 0;
		}
		if(m/<li>/g) {
			$li_found = 1;
		}
		if($flag) { $buf .= $_; }
	}
	close(HTML_PUB);
	
	if($li_found) { return $_[1]." ".$buf; }
	
	return $buf;
}

$year = $ARGV[0];

open(HTML, "public_html/reports/istlab-report-$year.html");
$output_buf = "";

for (<HTML>) {
	if(m/\[book\]/g) {
		$output_buf .= get_pubs("book","<h2>Monographs and Edited Volumes</h2>");
	} elsif(m/\[article\]/g) {
		$output_buf .= get_pubs("article","<h2>Journal Articles</h2>");
	} elsif(m/\[incollection\]/g) {
		$output_buf .= get_pubs("incollection","<h2>Book Chapters</h2>");
	} elsif(m/\[inproceedings\]/g) {
		$output_buf .= get_pubs("inproceedings","<h2>Conference Publications</h2>");
	} elsif(m/\[techreport\]/g) {
		$output_buf .= get_pubs("techreport","<h2>Technical Reports</h2>");
	} elsif(m/\[whitepaper\]/g) {
		$output_buf .= get_pubs("whitepaper","<h2>White Papers</h2>");
	} elsif(m/\[workingpaper\]/g) {
		$output_buf .= get_pubs("workingpaper","<h2>Working Papers</h2>");
	} else {
		$output_buf .= $_;
	}
}

close(HTML);

open(HTML, ">public_html/reports/istlab-report-$year.html");
print HTML $output_buf;
close(HTML);