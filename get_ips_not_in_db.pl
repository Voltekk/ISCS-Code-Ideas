use LWP::Simple;
use strict;
use warnings;
use HTML::TreeBuilder;
use HTML::FormatText;
use File::Slurp;
use List::Compare;

my $file = "C:/Perl/ip_skip_file.txt";
open(FILE, ">", $file) or die;

print "\nEnter the file containing IPs:\t";
my $fileip = <STDIN>;
chomp $fileip;

my @ips_to_check = split /\n/, read_file($fileip);

my $url = get("==============================");
my $format_url = HTML::FormatText->new();
my $treebuild = HTML::TreeBuilder->new();
my $parse = $treebuild->parse($url);
$parse = $format_url->format($parse);
$parse =~ s/\,/~/;
$parse =~ tr{~}{\n};

my @initial_split = split /\n+/, $parse;
my @ips_already_blocked;

for (my $x = 0; $x < $#initial_split + 1; $x++){
	my $check_line = $initial_split[$x];
	$check_line =~ s/(\s+)|(\t+)//;
	if ($check_line =~ /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){
		$check_line =~ s/[a-z]//ig;
		$check_line =~ s/\.{2,}|\,|\-//g;
		$check_line =~ s/\s+//g;
		push @ips_already_blocked, $check_line;
	}
}

print FILE "$_\n" for @ips_already_blocked;

close FILE;

my $lc = List::Compare->new(\@ips_already_blocked, \@ips_to_check);
my @intersection = $lc->get_intersection;

my @newlist = grep {!($_ ~~ @intersection)} @ips_to_check;

open (REPRINT, ">", $fileip) or die;
print REPRINT "$_\n" for @newlist;
close REPRINT;


my $here = "C:/Perl/here.txt";
open (HERE, ">", $here) or die;
print HERE $fileip;
close HERE;
exit();
