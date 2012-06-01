#!/usr/bin/perl
use warnings;
use strict;
use DBI;
use List::Util qw (max);


sub new {
    my ($class_name) = @_;
    my ($self) = {};
    my $id = 0;
    my $input;
    my @inputArray;

    bless ($self,$class_name);
    $self->{'_created'} = 1;
    return $self;
}

1;
