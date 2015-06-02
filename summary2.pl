use Lingua::EN::Summarize;
use File::Slurp;
use Lingua::EN::Fathom;


$input = <STDIN>;
chomp $input;

$file = read_file($input);

$text = Lingua::EN::Fathom->new();

$text->analyse_file($input);

$accumulate = 1;
$text->analyse_block($text_string, $accumulate);

$num_chars             = $text->num_chars;
$num_words             = $text->num_words;
$percent_complex_words = $text->percent_complex_words;
$num_sentences         = $text->num_sentences;
$num_text_lines        = $text->num_text_lines;
$num_blank_lines       = $text->num_blank_lines;
$num_paragraphs        = $text->num_paragraphs;
$syllables_per_word    = $text->syllables_per_word;
$words_per_sentence    = $text->words_per_sentence;


%words = $text->unique_words;
foreach $word ( sort keys %words ){
      print("$words{$word} :$word\n");
    }

$fog     = $text->fog;
$flesch  = $text->flesch;
$kincaid = $text->kincaid;

print($text->report);

$length = int(0.1*$num_chars + 0.5);

$summary = summarize($file, maxlength => $length);

$summaryfile = $input."summary.txt";
open(SUMMARY, ">", $summaryfile);
print SUMMARY $summary;
close SUMMARY;
