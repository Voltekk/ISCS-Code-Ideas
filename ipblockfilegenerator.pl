use Net::Whois::Raw qw( whois );
use File::Slurp;
use Locale::Country;

print "\nEnter the file containing IPs:\t";
$fileip = <STDIN>;
chomp $fileip;

$ipfile = read_file($fileip);
#$ipfile = s/:\d+//g;

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

        ### if you do "use Net::Whois::Raw qw( whois $OMIT_MSG $CHECK_FAIL 
        ###              $CACHE_DIR $CACHE_TIME $USE_CNAMES $TIMEOUT );
        ### you can use these:

  $OMIT_MSG = 1; # This will attempt to strip several known copyright
               # messages and disclaimers sorted by servers.
                #Default is to give the whole response.

  $OMIT_MSG = 2; # This will try some additional stripping rules
                #if none are known for the spcific server.

  $CHECK_FAIL = 1; # This will return undef if the response matches
                #one of the known patterns for a failed search,
                #sorted by servers.
                #Default is to give the textual response.

  $CHECK_FAIL = 2; # This will match against several more rules
                #if none are known for the specific server.

  $CACHE_DIR = "/var/spool/pwhois/"; # Whois information will be
                #cached in this directory. Default is no cache.

  $CACHE_TIME = 24; # Cache files will be cleared after not accessed
                #for a specific number of hours. Documents will not be
                #cleared if they keep get requested for, independent
                #of disk space. Default is not to clear the cache.

  $USE_CNAMES = 1; # Use whois-servers.net to get the whois server
                #name when possible. Default is to use the 
                #hardcoded defaults.


  $TIMEOUT = 10; # Cancel the request if connection is not made within
                #a specific number of seconds.
                
                
                print FILE $s;
                
                close FILE;

$read = read_file($file);

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
 exit;
