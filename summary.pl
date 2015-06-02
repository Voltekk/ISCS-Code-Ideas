use Text::Summarize::En;
use Data::Dump qw(dump);
use File::Slurp;
#use utf8;

print "Enter file to read:\t";
my $input = <STDIN>;
chomp($input);

my $input2 = "C:/Perl/intermediate.txt";
open(INPUT2, ">", $input2) or die;

my $output = 'c:/Perl/paragraphsplit.txt';
open (OUTPUT, '>'.$output) or die;

print "\nEnter file to output:\t";
my $output2 = <STDIN>;
chomp $output2;
open (OUTPUT2, '>'.$output2) or die;


my $tosum = read_file($input);
#$tosum =~	tr/A-Z/a-z/;
#$tosum =~	tr/.,:;!&?"'(){}\-\$\+\=\{\}\@\/\*\>\<//d;
#$tosum =~	s/[0-9]//g;
$tosum =~	s/\n+/ /g;
$tosum =~	s/\s+/ /g;
	my @paragraph = split(/\n/, $tosum);
	print OUTPUT "$_" for @paragraph;	

foreach my $para (@paragraph){
		my $summarizerEn = Text::Summarize::En->new();
		my $Parsed = $para;
		my $summary = $summarizerEn->getSummaryUsingSumbasic(listOfText => [$Parsed]);
		dump $summarizerEn->getSummaryUsingSumbasic(listOfText => [$Parsed]);
		print $summarizerEn;
		my $buffer = "";
		my $size = (length($Parsed))*0.05;
		my @sentence_list = map { $_->[0] } @{$summary->{idScore}};
		my @sentence_content;
		foreach my $tagged_sentence ( @{$summary->{listOfStemmedTaggedSentences}} ) {
    my @t;
    foreach my $element ( @{ $tagged_sentence } ) {
        my $Parsed = @$element[1];
        #issue 2
	# remove tabs and single new lines
        $Parsed =~ s/\t/ /;
        $Parsed =~ s/\n/ /;
	#, seems to work well for non-technical texts
	$Parsed =~ s/\s{2,}/ /;
        push @t, $Parsed;
    }
	#important to note here that this method uses /r in substitution so that original text files taken in $text
	#aren't substituted, rather a copy is made then the copy is placed in the substitution.
    	push @sentence_content, (join "", map { s/ +/ /gr } @t);
}
#while loop adds sentences joined in @sentence_content from the join "", map @t to the buffer until it is below the size
#limit
while ( length($buffer) < $size ) {
    $buffer .= join "\n", $sentence_content[(shift @sentence_list)];
	
}	
	print OUTPUT2 $buffer."\n\n";	
	}


$buffer2 = read_file($output2);

use RTF::Writer;
  $rtf = RTF::Writer->new_to_file($output2.".rtf");
  $rtf->prolog( 'title' => "Summary file" );
  $rtf->number_pages;
  $rtf->print(
    \'\fs40\b\i',  # 20pt, bold, italic
    $buffer2
  );
  $rtf->close;
