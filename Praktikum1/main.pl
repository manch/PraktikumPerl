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
do{
    $randomNumber = int(rand(8999)) + 1000;
}while ($core->numberWrong($randomNumber));

print "The random number:\t",$randomNumber,"\n";

print "Bulls and Cows\n\nLets play, give me a four-digit number:\n";
$userValue = $core->getPlayerNumber;
while($randomNumber ne $userValue){
 
        print "Bull:\t",$core->getBulls($randomNumber,$userValue),"\nCow:\t",$core->getCows($randomNumber,$userValue),"\n";
	print "Try again, give me a four-digit number:\n";
	$userValue = $core->getPlayerNumber;
}
print "WIN WIN WIN\n";
$play =0;
    
