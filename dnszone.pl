use strict;
use warnings;
use File::Slurp qw/read_file write_file/;

our @initial_file_data;
our @not_gw_ip;
our @not_gw_cname;




print "\nEnter filename:\t";
my $data_dnszone = &file_intake();

my $file = $data_dnszone."nsout.txt";
open(FILE, ">", $file) or die;



@initial_file_data = split /\n/, $data_dnszone;

for(my $i = 4; $i < $#initial_file_data - 3; $i++){
	my $data_line = $initial_file_data[$i];
	if ($data_line =~ /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){
		if($data_line !~ /(128\.164\.[0-9]{1,3}\.[0-9]{1,3})|(161\.253\.[0-9]{1,3}\.[0-9]{1,3})/){
			my $data_change = $data_line;
			$data_change =~ s/\t+|\s+/,/g;
			push @not_gw_ip, $data_change;
			my @data = split /\t+|\s+/, $data_line;
			my $init = $data[0];
			our $check_line = "CNAME\t".$data[0];
			our $check_line2 = "MX";
			for(my $k = 4; $k < $#initial_file_data - 3; $k++){
				my $data = $initial_file_data[$k];
				if($data =~ /\Q$check_line\E|\Q$check_line2\E/){
					my $data_change2 = $data;
					$data_change2 =~ s/\t+|\s+/,/g;
					push @not_gw_cname, $data_change2;
				}
			}
			undef $check_line;
			undef @data;
		}
	}
}


print FILE $_."\n" for @not_gw_ip;

print FILE $_."\n" for @not_gw_cname;


close FILE;
exit();


##################


sub file_intake(){
	my $file = <STDIN>;
	chomp $file;
	my $data = read_file($file);
	return $data;
	undef $file;
	undef $data;
}
