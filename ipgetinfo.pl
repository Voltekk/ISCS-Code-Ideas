use Net::Whois::Raw qw( whois );
use File::Slurp;
use Locale::Country;

$file = "C:/Perl/ipstripfile.txt";
open (FILE, ">", $file);

print "\nEnter an ip:\t";
$ip = <STDIN>;

chomp $ip;
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
	elsif($checkline =~ /org-name:|OrgName:/i){
		$checkline =~ s/org-name:|OrgName://i;
		$checkline =~ s/(\s+)|(\t+)//;
		push @info, $checkline;
	}
	
  
 }
              $string = join(" || ", @country);
              $string2 = join("", @info);
              
              $block_ready_string = $ip.";".$string." || ".$string2;
              
              $block_ready_string !~ s/[^[:ascii:]]|'|"|“|”|’|!|\?//;
              
              print $block_ready_string;
 
 @country = ();
 @info = ();
 
 print @country;
 print "\n";
 print @info;             
  
 exit;
