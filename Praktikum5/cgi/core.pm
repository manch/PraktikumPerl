#!/usr/bin/perl
use warnings;
use strict;
use DBI;
use List::Util qw (max);

my $id = 0;
my $dbh = DBI::->connect("dbi:SQLite:dbname=myAddManSys.db","","");
my $input;
my @inputArray;

sub new {
    my ($class_name) = @_;
    my ($self) = {};

    bless ($self,$class_name);
    $self->{'_created'} = 1;
    return $self;
}


1;
