use strict;
use warnings;

while(){
	my $what_to_query = &query("Enter 1 for IP 2 for domain");
	if ($what_to_query !~ /1|2/){
		print "Invalid entry";
		next;
	}
	elsif($what_to_query =~ /1/){
		my $ip = &query("Enter IP");
		my $domaintools = "whois.domaintools.com/".$ip;
		my $virustotal = "https://www.virustotal.com/en/ip-address/".$ip."/information/";
		my $shodan = "https://www.shodan.io/host/".$ip;
		my $command = "chrome ";
		system($command.$domaintools);
		system($command.$virustotal);
		system($command.$shodan);
	}
	elsif($what_to_query =~ /2/){
		my $domain = &query("Enter domain");
		my $domaintools = "whois.domaintools.com/".$domain;
		my $virustotal = "https://www.virustotal.com/en/domain/".$domain."/information/";
		my $command = "chrome ";
		system($command.$domaintools);
		system($command.$virustotal);
	}
	else{
		next;
	}
}

sub query(){
	my $question = shift;
	print "\n".$question.":\t";
	my $input = <STDIN>;
	chomp $input;
	return $input;
	undef $input;
	undef $question;
}
