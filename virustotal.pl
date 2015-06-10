use strict;
use warnings;
use VT::API;
use Data::Dump qw/dump/;


print"\nLimitations on use:\n1)\tRequest Rate:\t4 per minute\n2)\tDaily Quota:\t5760 per day\n3)\tMonthly Quota:\t178560\n";



print "\nEnter public API key:\t";
my $key = <STDIN>;
chomp $key;


while(){
	my $api = VT::API->new(key => $key);
	print "\nEnter IP/URL to retrieve report:\t";
	my $ipurl = <STDIN>;
	chomp $ipurl;
	if($ipurl =~ /exit/i){
		last;
	}
	my $retrieve = $api->get_url_report($ipurl);
	my $analysis = dump $retrieve;
	print $analysis;
}

exit;
