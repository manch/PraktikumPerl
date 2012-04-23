#!/usr/bin/perl
use warnings;
use strict;
use myCore;

my $core = new myCore;
my $randomNumber = $core->getRandomNumber;
my $userValue;

print "The random number:\t",$randomNumber,"\n";

print "Bulls and Cows\n\nLets play, give me a four-digit number:\n";
$userValue = $core->getPlayerNumber;

while ($core->isNotFinish($randomNumber, $userValue)){ 
        print "Bull:\t",$core->getBulls($randomNumber,$userValue),"\nCow:\t",$core->getCows($randomNumber,$userValue),"\n";
	print "Try again, give me a four-digit number:\n";
	$userValue = $core->getPlayerNumber;
}
print "WIN WIN WIN\n";
    
