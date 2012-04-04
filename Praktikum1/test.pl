use strict;
use warnings;
use Data::Random qw(rand_chars);
use List::MoreUtils qw(all any true uniq);
my @array;
my @a;
@array = rand_chars(set => [1..9], size => 4);
@a = (1,1,2,3);
print @array,"\n";

if ( any { ! defined($_) } @array ) {
    print "ANY machter\n";
} 
if ( all { defined($_) } @array ) {
    print "ALL machter\n";
}
@a = uniq @a;
if ((true { defined($_) } @a) != 4){
    print "die eingabe ist falsch\n";
}
printf "%i item(s) are defined\n", true { defined($_) } @array;
