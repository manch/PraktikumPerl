#!/usr/bin/perl

use warnings;
use strict;
use Moose;

use myAddress;

class myAddressBook{

    has "addresses" => ( "is" => "rw",
			 "traits" => ["Array"],
			 "required" => 0,
			 "default" => sub {[]},
			 "isa" => "ArrayRef[myAddress]",
			 "handles" => {
			     "address" => "elements",
			     "num_address" => "count",
			     "add_address" => "push",
			     "get_address" => "get",
			     "delete_address" => "delete"
		 }
	);


    method address_exists(Int $id) {
	return $id < $self->num_address;
    }

    method print_list {
	print "Contacts:\t".$self->num_address."\n";
	my $Id = 0;
	foreach my $address ($self->address){
	    $Id++;
	    print "ID:\t$Id\n";
	    $address->browse();
	}
    }

    method search_Text(Str $searchText) {
	my $id = 0;
	foreach my $address ($self->address){
	    my @contact = ($address->name, $address->lastname, $address->entry_field_values);
	    $id++;
	    if(grep{$_=~ $searchText;}@contact){ print "ID:\t\t$id\n"; $address->browse(); } ;
	}
    }

}

1;
