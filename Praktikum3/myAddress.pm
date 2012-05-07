#!/usr/bin/perl

use warnings;
use strict;
use MooseX::Declare;

class myAddress{
    has "name" => ("is" => "rw", "required" => 1, "isa" => "Str");
    has "lastname" => ("is" => "rw", "required" => 1, "isa" => "Str");
    has "entry" => ("is" => "rw",
		    "traits" => ["Hash"],
		    "required" => 0,
		    "default" => sub {{}},
		    "isa" => "HashRef",
		    "handles" => {
			"entry_field" => "accessor",
			"entry_field_keys" => "keys",
			"entry_field_values" => "values",
			"entry_field_delete" => "delete",
			"entry_field_count" => "count"
		    }
	);
    
    method browse_address {
	print "Name:\t\t".$self->name."\n";
	print "Lastname:\t".$self->lastname."\n";
	
	foreach my $key ($self->entry_field_keys){
	    print "".$key.":\t\t".$self->entry_field($key)."\n";
	}
    }
}

1;
