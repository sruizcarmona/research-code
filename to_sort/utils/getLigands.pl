#!/usr/bin/perl
use warnings;

$file=$ARGV[0];


open(IN,"$file");
$i=0;$n=0;$check=0;
$prevprev="";
$prev ="";

while(<IN>){
	chomp;
	$line=$_;
	
	if($prevprev =~ /i_i_glide_posenum/ && $prev =~ /\:\:\:/){
		$lig[$i] = $line;
		$i++;
	}
	if ($prevprev =~ /i_i_glide_posenum/ && $prev !~ /\:\:\:/) {$check=1;}
	if ($prev =~ /\:\:\:/ && $check==1){
		$lig[$i] = $line;
		$check=0;
		$i++;
	}
	if($n > 2){$prevprev=$prev};
	if($n > 1){$prev=$line};
	$n++;
	
}
close(IN);

print (join("\n",@lig),"\n");
