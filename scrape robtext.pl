use strict;
use warnings;
use LWP::Simple qw/get/;
use HTML::TreeBuilder;
use HTML::FormatText;

print "\nMake sure to have chrome, mozilla, or browser of choice set to ENV PATH. Modify line 21 to ensure right system call to pull up DNS graph.\n\n"; 

while(){
	my $file = make_output_file();
	open(FILE, ">>", $file) or die;
	my @research = &get_ip_or_site();
	for(my $i = 0; $i < 5; $i++){
		if($i != 3){
			my $url = $research[$i];
			my $url_data = &get_url_clean($url);
			print FILE $url_data."\n";
			my $command = "chrome ".$url;
			system($command);
		}
		else{
			my $url4 = $research[3];
			my $command = "chrome ".$url4;
			system($command);
		}
	}
	close FILE;
	undef $file;
}

##############################################################################
sub make_output_file(){
	print "\nEnter an output file for this query:\t";
	my $file = <STDIN>;
	chomp $file;
	return $file;
	undef $file;
}

sub get_ip_or_site(){
	print "\nEnter website or IP to investigate:\t";
	my @array_hold;
	my $investigate = <STDIN>;
	chomp $investigate;
	my $string = "http://www.robtex.com/?dns=";
	my $scoring = "&scorecard=1";
	my $shared = "&shared=1";
	my $graph = "&graph=1";
	my $string_query = "http://www.robtex.com/?q=";
	$array_hold[0] = $string.$investigate;
	$array_hold[1] = $string.$investigate.$scoring;
	$array_hold[2] = $string.$investigate.$shared;
	$array_hold[3] = $string.$investigate.$graph;
	$array_hold[4] = $string_query.$investigate;
	return @array_hold;
	undef $investigate;
	undef @array_hold;
}

sub get_url_clean(){
	my $address = shift;
	my $url_data = get($address);
	my $format_url = HTML::FormatText->new();
	my $treebuild = HTML::TreeBuilder->new();
	my $parse = $treebuild->parse($url_data);
	$parse = $format_url->format($parse);
	return $parse;
}
