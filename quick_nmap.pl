use strict;
use warnings;
use File::Slurp qw/read_file write_file/;

our @nmap_commands;
our $base_command = "nmap -vv -Pn -sS -sU";

print "\nThis is a script to scan the network using nmap. Be sure that nmap is present on the current system before you begin\n";
print "\nEnter the output file for the data:\t";

our $file = <STDIN>;
chomp $file;
our $file_base = $file;

print "\nEnter the file list of ips (this should be a file where an ip is on a new line) you are interested in scanning:\t";
my $ip_file = <STDIN>;
chomp $ip_file;
my $ip_data = &read_input($ip_file);
my @ip_list = split /\n+/, $ip_data;

print "\nEnter the location of list of ports to scan:\t";
my $ports_file = <STDIN>;
chomp $ports_file;
my $port_data = &read_input($ports_file);
our @ports_list = split /\n+/, $port_data;

for(my $j = 0; $j < $#ip_list + 1; $j++){
	my $ip = $ip_list[$j];
	my $port = $ports_list[0].",".$ports_list[1];
	my $command = $base_command." -p ".$port." ".$ip;
	push @nmap_commands, $command;
}

print "\nPreparation complete... now running scans against hosts...\n\n\n";

for(my $k = 0; $k < $#nmap_commands + 1; $k++){
	$file = $file.$k.".txt";
	my $send_command = $nmap_commands[$k]." -oN ".$file;
	system($send_command);
	$file = $file_base;
}

#################################################################################################################################

sub read_input(){
	my $file = shift;
	my $file_content = read_file($file);
	return $file_content;
	undef $file;
}
