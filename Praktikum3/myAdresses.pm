package myAdresses;
use strict;
use warnings;
use Moose;

has id => (is => "ro");
has name =>(is => "rw");
has lastName=>(is=>"rw");
has from=>(is=>"rw");
has plz=>(is=>"rw");
has street=>(is=>"rw");

sub browse{
    my ($self,$b1,$b2) = @_;
    print $b1.$b2;
}








1;
