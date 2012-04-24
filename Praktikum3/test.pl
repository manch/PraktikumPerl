#!/usr/bin/perl
use warnings;
use strict;
use myAdresses;

my $adress = myAdresses->new();
$adress->name("David");
print $adress->name();

$adress->browse("bla1","bla2");
