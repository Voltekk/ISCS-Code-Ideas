use Net::Whois::Raw qw( whois );
use File::Slurp;
use Locale::Country;

system('get_ips_not_in_db.pl');
system('check_tor.pl');

$container = "C:/Perl/here.txt";
$fileip = read_file($container);
$ipfile = read_file($fileip);
@iplist = split /\n/, $ipfile;
$csv = "C:/Perl/IP.csv";
open(CSV, ">>", $csv) or die;
print "\nEnter Date:\t";
$date = <STDIN>; 
chomp $date;
print CSV "\n".$date."\n";

for($l = 0; $l < $#iplist+1; $l++){
	$file = "C:/Perl/ipstripfile.txt";
	open (FILE, ">", $file) or die;
	$ip = $iplist[$l];
	$ip =~ s/\s+//;
  
	$s = whois($ip);
	$OMIT_MSG = 1;
	$OMIT_MSG = 2; 
	$CHECK_FAIL = 1;
	$CHECK_FAIL = 2;
	$CACHE_DIR = "/var/spool/pwhois/";
	$CACHE_TIME = 24;
	$USE_CNAMES = 1;
	$TIMEOUT = 10;
	print FILE $s;
	close FILE;

	$read = read_file($file);
	$read =~ s/,|\(|\)//g;
	@lines = split /\n/, $read;
	@country;
	@info;

	for($i = 0; $i < $#lines; $i++){
		$checkline = $lines[$i];
		if($checkline =~ /country:/i){
			$checkline =~ s/country://i;
			$checkline =~ s/(\s+)|(\t+)//;
			if($checkline =~ /US/){
				push @country, $checkline;
				for($j = 0; $j < $#lines; $j++){
					$us_info = $lines[$j];
					if($us_info =~ /City:|StateProv:/i){
						$us_info =~ s/City:|StateProv://i;
						$us_info =~ s/(\s+)|(\t+)//;
						push @country, $us_info;
					}
				}
			}
			else{
				$checkline = code2country($checkline);
				$checkline =~ s/\,//g;
				$checkline =~ s/the republic of//g;
				$checkline =~ s/\s+/ /g;
				push @country, $checkline;
			}
		}
	}
	
	for($k = 0; $k < $#lines; $k++){
		$checkline_2 = $lines[$k];
		if($checkline_2 =~ /owner:/i){
			$checkline_2 =~ s/owner://i;
			$checkline_2 =~ s/(\s+)|(\t+)//;
			if($checkline_2 =~ /\w+/){
				push @info, $checkline_2;
			}
		}
	}
 	
	for($o = 0; $o < $#lines; $o++){
		$checkline_3 = $lines[$o];
		if($checkline_3 =~ /org-name:|OrgName:|netname:/ && $info[0] !~ /\w+/){
			$checkline_3 =~ s/org-name:|OrgName:|netname://i;
			$checkline_3 =~ s/(\s+)|(\t+)//;
			$checkline_3 =~ s/\,\s+?LLC/ LLC/;
			push @info, $checkline_3;
		}
	}
 
	if($country[0] =~ /US/){
		$string = $country[0]." ".$country[1]." ".$country[2];
	}
	else{
		$string = $country[0];
		$string =~ s/\((\w+\s?)+\)//i;
	}

	$string2 = join("", @info);
        print "\nEnter a reason to block IP $ip:\t";
	$reason = <STDIN>;
	chomp $reason;
              
	$block_ready_string = $ip.";".$string." || ".$string2." || ".$reason;
	$block_ready_string !~ s/[^[:ascii:]]|'|"|“|”|’|!|\?//;
	print $block_ready_string;
	print CSV $block_ready_string."\n";
 
	undef @country;
	undef @info; 
	undef $ip;
	undef $s;
 
	print @country;
	print "\n";
	print @info;             
}
	
close CSV;
exit();
