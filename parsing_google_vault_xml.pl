#xml doesn't do anything, it just represents data
#xml often starts with information in the first line, often absent in practice
#order of subelements don't matter
#attributes are name value pairs

#!/usr/bin/perl

use strict;
use warnings;
use File::Slurp;

print "Enter your XML file: \t";
our $xml = <STDIN>;	
chomp $xml;

our $text = "output.txt";
open(TEST, ">", $text);

our $txt = $xml.".txt";
open(TXT, ">", $txt) or die "Can't create csv file";

our @conglomerate_data;
our @data_for_csv;

if(-e $xml){
	my $text_of_xml = read_file($xml); 
	my @lines = split /\n/, $text_of_xml;
	foreach my $line (@lines) {
		if($line =~ /DocID|TagName|ExternalFile/){
			$line =~ s/<|>|#|\///g;
			my @refine_xml_data = split/='/, $line;	
			push @conglomerate_data, @refine_xml_data;
		}
	}
	print TEST $_."\n" for @conglomerate_data;
	close TEST;
	for(my $i = 0; $i < $#conglomerate_data; $i++){
		my $line_of_array = $conglomerate_data[$i];
		if($line_of_array =~ /DocID/){
			my $line_to_save = $conglomerate_data[$i+1]."=;".$conglomerate_data[$i+5].";".$conglomerate_data[$i+9].";".$conglomerate_data[$i+13].";".$conglomerate_data[$i+17].";".$conglomerate_data[$i+21].";".$conglomerate_data[$i+25].";".$conglomerate_data[$i+29].";".$conglomerate_data[$i+33].";".$conglomerate_data[$i+35].";".$conglomerate_data[$i+36].";".$conglomerate_data[$i+37];
			$line_to_save =~ s/'|FileSize|Hash|Document DocID//g;
			$line_to_save =~ s/\t+|\n+|\s+/ /g;
			push @data_for_csv, $line_to_save;
		}
	}
	print TXT "DocID;Labels;From;To;CC;BCC;Subject;DateSent;DateRecieved;FileName;FileSize;Hash\n\n";
	print TXT $_."\n" for @data_for_csv;
	close TXT;
}
else{
	exit();
}

exit();
