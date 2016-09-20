use strict;
use warnings;
use List::MoreUtils qw /uniq/;
use File::Slurp qw/read_file write_file/;

my $file = "traffic.csv";

my $data = read_file($file);

my @lines = split /\n+/, $data;

our @pairs;

our @just_ips;
our @just_ips_print;

our @just_ports;
our @just_ports_print;

foreach my $line (@lines){
    my @ip_port = split /,/, $line;
    my $combined = $ip_port[5].":".$ip_port[6];
    push @pairs, $combined;
    push @just_ips, $ip_port[5];
    push @just_ports, $ip_port[6];
    undef $combined;
    undef @ip_port;
}

@pairs = uniq @pairs;

my $outputfile = $file."out.txt";
open(FILE, ">", $outputfile) or die;

print FILE $_."\n" foreach @pairs;

close FILE;


@just_ips_print = uniq @just_ips;


@just_ports_print = uniq @just_ports;

foreach my $ip (@just_ips_print){
    my $count = grep(/\Q$ip\E/, @just_ips);
    my $size = @just_ips;
    my $percentage = $count/($size - 1) * 100;
    $ip = $ip."\t".$percentage."%";
    print $ip."\n";
    undef $count;
    undef $size;
    undef $percentage;
}

foreach my $port (@just_ports_print){
    my $count = grep(/\Q$port\E/, @just_ports);
    my $size = @just_ports;
    my $percentage = $count/($size - 1) * 100;
    $port = $port."\t".$percentage."%";
    print $port."\n";
    undef $count;
    undef $size;
    undef $percentage;
}

my $statfile = $file."stat.txt";
open(STAT, ">", $statfile) or die;

print STAT $_."\n" for @just_ips_print;

print STAT "==================\n";

print STAT $_."\n" for @just_ports_print;

close STAT;

exit();
