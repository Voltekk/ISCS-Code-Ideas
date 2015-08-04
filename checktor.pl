use LWP::Simple;
use strict;
use warnings;
use HTML::TreeBuilder;
use HTML::FormatText;
use File::Slurp;

my @not_tor;

my $contains = "C:/Perl/here.txt";
my $ip_file = read_file($contains);
my $ips = read_file($ip_file);

my @ip_list = split/\n+/,$ips;

for(my $k = 0; $k < $#ip_list; $k++){
	my $ip_line = $ip_list[$k];
	my $dan_format = "https://www.dan.me.uk/torcheck?ip=";
	my $url = get($dan_format.$ip_line);
	my $formatter = HTML::FormatText->new();
	my $treeclear = HTML::TreeBuilder->new();
	my $new_text = $treeclear->parse($url);
	my $parsed = $formatter->format($new_text);
	#print $parsed;
		
	my @formulate = split /\n+/, $parsed;
	my @information;

	for(my $i = 0; $i < $#formulate + 1; $i++){
		my $line = $formulate[$i];
		if($line =~ //){
			push @information, $line;
		}
	}

	my $file = "C:/Perl/torcheck.txt";
	open(FILE, ">", $file) or die;
	print FILE $_."\n" for @information;
	close FILE;
	
	my $checking = read_file($file);
	if($checking =~ /% The IP address is \*not\* a TOR Node/){
		push @not_tor, $ip_line;
	}
}

open(FILE, ">", $ip_file) or die;
print FILE $_."\n" for @not_tor;
close FILE; 
