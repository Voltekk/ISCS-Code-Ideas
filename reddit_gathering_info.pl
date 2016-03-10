use strict;
use warnings;
use feature 'say';
use Reddit::Client;
use utf8;
use LWP::Simple;
use HTML::TreeBuilder;
use HTML::FormatText;
use Data::Dump qw/dump/;
use Text::TermExtract;
use List::MoreUtils qw/uniq/;
use File::Slurp;


#http://www.perlmonks.org/index.pl?abspart=1;displaytype=displaycode;node_id=1116818;part=1

#using the reddit::client is not my code. base taken from link above 

our $config_file_topic = "C:/Perl/topic_config.txt";
our $config_file_preferred_keywords = "C:/Perl/topic_preferred_config.txt";

print "\nEnter the topic you wish to query:\t";

my $query_topic = <STDIN>;
chomp $query_topic;

print "\nEnter how many pages of information you would like to get:\n";

while(){
    print "\nEnter a valid input:\t";
    our $page_last = <STDIN>;
    chomp $page_last;
    $page_last =~ s/\D//g;
    $page_last =~ s/\t|\s//g;
    if($page_last =~ /[0-9]+/ && $page_last > 1){
        last;
    }
}

my @subreddit_request = uniq (get_subreddit($query_topic));

print "\nYour topics:\n";
print "$_\n" for @subreddit_request;
print "\nEnter the names of the subreddits you want to remove. Delimit each subreddit name with a comma (ex: forensics, computers, technology):\t";
my $topic_query = <STDIN>;
chomp $topic_query;
@topic_query_array = split /,/, $topic_query;
for(my $k = 0; $k < $#topic_query_array; $k++){
    $topic_compare_a = $topic_query_array[$k];
    for(my $l = 0; $; < $#subreddit_request; $l++){
        $topic_compare_b = $subreddit_request[$l];
        if($topic_compare_b =~ /\/r\/$topic_compare_a/i){
            $topic_compare_b = "";
        }
    }
}

if(-e $config_file_topic){
        open(CONFIG, ">>", $config_file_topic) or die;
        print CONFIG "$_\n" for @subreddit_request;
        close CONFIG;
}
else{
    open(CONFIGUR, ">", $config_file_topic) or die;
    print CONFIGUR, "$_\n" for @subreddit_request;
    close CONFIG;
}

for(my $j = 0; $j < $#subreddit_request+1; $j++){
    my $subreddit    = $subreddit_request[$j];
    my $limit        = 25;
    my $reddit       = Reddit::Client->new(user_agent => 'MyApp/1.0');

    my $last_post;
    foreach my $page (1 .. $page_last) {
        my $links = $reddit->fetch_links(
            subreddit => $subreddit,
            limit     => $limit,
            after     => $last_post
        );
        foreach my $link (@{ $links->{items} }) {
            my $parse = $link->{title};
            say $subreddit, ': ', $page, ': ', $parse;
        }
        $last_post = $links->{items}->[-1]->{name};
    }
}


exit;


####################################################################################


sub get_subreddit{
    use LWP::Simple qw/get/;
    my @subreddit_array;
    my $topic = shift;
    $topic =~ s/\s/%20/;
    $topic =~ s/'/%27/;
    my $url = "http://www.reddit.com/search?q=".$topic;
    say $url;
    my $page = get($url);
    my $format = HTML::FormatText->new();
    my $treebuilder = HTML::TreeBuilder->new();
    my $parsed_page = $treebuilder->parse($page);
    $parsed_page = $format->format($parsed_page);
    my @lines = split /\s/, $parsed_page;
    for(my $i = 0; $i < $#lines+1; $i++){
        my $liner = $lines[$i];
        if($liner =~ /\/r\/[a-z]+/i){
            push @subreddit_array, $liner;
        }
    }
    return @subreddit_array;
}

sub yes_no_page{
    my $page = shift;
    print "\nWould you like to keep this page $page? (Y/N)\t";
    my $yes_no = <STDIN>;
    chomp $yes_no;
    if($yes_no =~ /Y/){
        my $page_data = get_url_data($page);
        my @page_keys = keyword_retrieve($page_data);
        open(CONF, ">>", $config_file_preferred_keywords);
        print CONF "$_\n" for @page_keys;
        close CONF;
    }
    elsif($yes_no =~ /N/){
        print "$page skipped\n";
    }
    else{
        print "Invalid input, $page skipped.\n";
    }
    undef $yes_no;
}

sub get_url_data{
    use LWP::Simple qw/get/;
    my $address = shift;
    my $url_data = get($address);
    my $format_url = HTML::FormatText->new();
    my $treebuild = HTML::TreeBuilder->new();
    my $parse = $treebuild->parse($url_data);
    $parse = $format_url->format($parse);
    return $parse;
}


sub keyword_retrieve{
    use File::Slurp;
    my $data = shift;
    my @terms;
    my $extract = Text::TermExtract->new();
    for my $extracted_terms($extract->terms_extract($data), {max => 5}){
        push @terms, $extracted_terms;
    }
    return @terms;
}
