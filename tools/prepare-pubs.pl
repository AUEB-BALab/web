#!/usr/bin/perl

# amateurish but working ... need to catch that deadline :)

sub get_pubs {
	$flag = 0;
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
		if($flag) { $buf .= $_; }
	}
	close(HTML_PUB);
	
	return $buf;
}

$year = $ARGV[0];

open(HTML, "public_html/reports/istlab-report-$year.html");
$output_buf = "";

for (<HTML>) {
	if(m/\[book\]/g) {
		$output_buf .= get_pubs("book");
	} elsif(m/\[article\]/g) {
		$output_buf .= get_pubs("article");
	} elsif(m/\[incollection\]/g) {
		$output_buf .= get_pubs("incollection");
	} elsif(m/\[inproceedings\]/g) {
		$output_buf .= get_pubs("inproceedings");
	} elsif(m/\[techreport\]/g) {
		$output_buf .= get_pubs("techreport");
	} elsif(m/\[whitepaper\]/g) {
		$output_buf .= get_pubs("whitepaper");
	} elsif(m/\[workingpaper\]/g) {
		$output_buf .= get_pubs("workingpaper");
	} else {
		$output_buf .= $_;
	}
}

close(HTML);

open(HTML, ">public_html/reports/istlab-report-$year.html");
print HTML $output_buf;
close(HTML);