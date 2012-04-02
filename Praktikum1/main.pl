#!/usr/bin/perl
use warnings;
use strict;
use myCore;

#$| =1;
#vierstellige nr ziehen
#pruefen oder one step back

my $randomNumber;
my $core;
$core = new myCore;
my $userValue;
my $i;
my $play;
$play = 1;
$i = 1;
while ($i){
    $randomNumber = int(rand(8999)) + 1000;
    if ($core->numberOk($randomNumber)){
	$i = 0;
    }
    else{
	$i = 1;
    }
}
print "The random number:\t",$randomNumber,"\n";

print "Bulls and Cows\n\nLets play, give me a four-digit number:\n";
$userValue = $core->getPlayerNumber;
while($play){
 
    if ($randomNumber eq $userValue){
        print "WIN WIN WIN\n";
	$play =0;
    }
    else{
        print "Bull:\t",$core->getBulls($randomNumber,$userValue),"\nCow:\t",$core->getCows($randomNumber,$userValue),"\n";
	print "Try again, give me a four-digit number:\n";
	$userValue = $core->getPlayerNumber;
    }
}
