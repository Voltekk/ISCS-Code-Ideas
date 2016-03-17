use strict;
use warnings;


our $letter;
my $input_directory = &input();
my $output_drive = &output();
my $case_name = &case($letter, $output_drive);
my $fciv = &fciv();

my $fciv_command = $fciv." -add ".$input_directory." -r -both -xml $output_drive"."output.xml";

system($fciv_command);

my $robo_command = "start robocopy ".$input_directory." ".$case_name;

system($robo_command);

my $fciv_verify = "start ".$fciv." -add ".$case_name." -r -both -xml $output_drive"."outverify.xml";

system($fciv_verify);

exit();
###################################################################


sub input(){
	print "\nEnter the directory to robocopy:\t";
	my $input_directory = <STDIN>;
	chomp $input_directory;
	if(-e $input_directory){
		return $input_directory;
		$input_directory = undef;
	}
	else{
		print $input_directory." is invalid\n";
		exit();
	}
}

sub output(){
	print "\nEnter the output drive letter (only the letter!):\t";
	my $output_drive = <STDIN>;
	chomp $output_drive;
	$letter = $output_drive;
	if($output_drive =~ /\b[A-Z]\b/i){
	$output_drive = $output_drive.":/";
		if(-e $output_drive){
			return $output_drive;
			$output_drive = undef;
		}
		else{
			print "\nThe drive does not exist";
			exit();
		}
	}
	else{
		print $output_drive." is invalid\n";
		exit();
	}
}

sub case(){
	my $drive_letter = shift;
	my $output_folder = shift;
	print "\nEnter the name of the case:\t";
	my $case_name = <STDIN>;
	chomp $case_name;
	my $destination = $output_folder.$case_name;
	my $command1 = $letter.":";
	system($command1);
	my $command2 = "mkdir ".$case_name;
	system($command2);
	return $destination;
	$case_name = undef;
}

sub fciv(){
	print "\nEnter the directory containing fciv (without slash at the end):\t";
	my $fciv_dir = <STDIN>;
	chomp $fciv_dir;
	$fciv_dir =~ s/\\/\//g;
	my $fciv = $fciv_dir."/fciv.exe";
	if(-e $fciv){
		return $fciv;
		$fciv_dir = undef;
	}
	else{
		print "\nDirectory is invalid";
		exit();
	}
}
