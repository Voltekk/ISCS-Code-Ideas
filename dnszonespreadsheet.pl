use strict;
use warnings;
use File::Slurp qw/read_file write_file/;

#our @initial_file_data;
#our @not_gw_ip;
#our @not_gw_cname;


our $file = "nsout.txt";
our $file2 = "notgwout.txt";
#open(FILE, ">", $file) or die;

print "\nEnter files separated by commas:\t";
our $file_list = <STDIN>;
chomp $file_list;
my @file_holder = split /,/ , $file_list;

foreach my $filename (@file_holder){
    my $data = read_file($filename);
    my @lines = split /\n+/ , $data;
    my @a_records;
    my @mx_records;
    my @cname_records;
    my @not_gwu_ip;
    foreach my $data_line (@lines){
        if ($data_line =~ /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){
            if($data_line =~ /\t+A\t+/){
                push @a_records, $data_line;
            }
            
        }
        elsif($data_line =~ /MX/){
            push @mx_records, $data_line;
        }
        elsif($data_line =~ /CNAME/){
            push @cname_records, $data_line;
        }
    }
    foreach my $a (@a_records){
        if($a !~ /(128\.164\.[0-9]{1,3}\.[0-9]{1,3})|(161\.253\.[0-9]{1,3}\.[0-9]{1,3})/){
            push @not_gwu_ip, $a;
        }
        our @container = split /\s+|\t+/, $a;
        our $check = $container[0];
        foreach my $mx (@mx_records){
            if($mx =~ /\Q$check\E/){
                push @not_gwu_ip, $mx;
            }
        }
        foreach my $cname (@cname_records){
            if($cname =~ /\Q$check\E/){
                push @not_gwu_ip, $cname;
            }
        }
        undef @container;
        undef $check;
    }
    foreach my $i (@a_records){
        $i =~ s/\t+|\s+/,/g;
    }
    foreach my $j (@mx_records){
        $j =~ s/\t+|\s+/,/g;
    }
    foreach my $k (@cname_records){
        $k =~ s/\t+|\s+/,/g;
    }
    foreach my $l (@not_gwu_ip){
        $l =~ s/\t+|\s+/,/g;
    }
    my $all_file = $filename.$file;
    my $not_gw_file = $filename.$file2;
    open (GW, ">>", $all_file) or die;
    open (NGW, ">>", $not_gw_file) or die;
    print GW $_."\n" for @a_records;
    print GW $_."\n" for @mx_records;
    print GW $_."\n" for @cname_records;
    print NGW $_."\n" for @not_gwu_ip;
    close GW;
    close NGW;
    undef $all_file;
    undef $not_gw_file;
    undef @a_records;
    undef @mx_records;
    undef @cname_records;
    undef @not_gwu_ip;
    undef $data;
    system('perl dnszone.pl');
    system('perl dnszone.pl');
    system('perl dnszone.pl');
}

#my $data_dnszone = &file_intake(); 



#@initial_file_data = split /\n/, $data_dnszone;

#for(my $i = 4; $i < $#initial_file_data - 3; $i++){
#	my $data_line = $initial_file_data[$i];
#	if ($data_line =~ /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){
#		if($data_line !~ /(128\.164\.[0-9]{1,3}\.[0-9]{1,3})|(161\.253\.[0-9]{1,3}\.[0-9]{1,3})/){
#			push @not_gw_ip, $data_line;
#			my @data = split /\t+|\s+/, $data_line;
#			our $check_line = "CNAME\t".$data[0];
#			for(my $k = 4; $k < $#initial_file_data - 3; $k++){
#				my $data = $initial_file_data[$k];
#				if($data =~ /\Q$check_line\E/){
#					push @not_gw_cname, $data;
#				}
#			}
#			undef $check_line;
#			undef @data;
#		}
#	}
#}

#print FILE $_."\n" for @not_gw_ip;

#print FILE $_."\n" for @not_gw_cname;


#close FILE;
exit();


