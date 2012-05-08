#!/usr/bin/perl
use warnings;
use strict;
use Storable qw (store retrieve);
use myAddressBook;
use myAddress;

my $addressBook;
#wird für storeable gebraucht
if ( -e "data" ){ $addressBook = retrieve ("data");}else{ my $tmp = myAddressBook->new(); $addressBook = \$tmp;}; 

#my $addressBook = myAddressBook->new();
my $input;
my @inputArray;

while(1){
    print "(Address Management) ";
    chomp( $input = <stdin>);    
    if($input eq "") {redo;}
    if ($input eq "e"){
	newAdress();
	redo;
    }
    elsif($input eq "l"){
	list();
	redo;
    }
    elsif($input eq "h"){
	browseHelp();
	redo;
    }
    @inputArray = split(" ", $input);
    if ($inputArray[0] eq "a"){
	appendAdress($inputArray[1]);
	redo;
    }
    elsif ($inputArray[0] eq "d"){
	deleteById($inputArray[1]);
	redo;
    }
    elsif ($inputArray[0] eq "l"){	
	listById($inputArray[1]);
	redo;
    }
    elsif ($inputArray[0] eq "s"){
	searchText($inputArray[1]);
	redo;
    }
    if($input eq "exit" || $input eq "q" || $input eq "quit"){
	last;
    }
}

store $addressBook,"data";

sub newAdress{
    print "(newAdress) Enter your name: ";
    chomp (my $name = <stdin>);
    
    print "(newAdress) Enter your lastname: ";
    chomp (my $lastname = <stdin>);

    my $addresstmp = myAddress->new("name" => $name,
				 "lastname" => $lastname
	);
    my $address = \$addresstmp;

    while (1){
	print "(newAdress) ";
	chomp($input = <stdin>);
	if($input eq "") {redo;}
	if($input eq "."){last;};
	if($input =~ ":"){
	    my($key, $val) = split(":",$input);
	    ${$address}->entry_field($key,$val);
	}
    }
    ${$addressBook}->add_address(${$address});
}

sub list{
    ${$addressBook}->print_list;
}

sub browseHelp{
    print "e\t\tAdd a new address\n\t\tForm: 'key:value'\n\t\tFinish with '.'\n\n";
    print "a id\t\tChange or add an adress item: 'key:value'\n\t\tFinish with '.'\n\n";
    print "d id\t\tDelete address on this id\n\n";
    print "l id\t\tBrowse address on the given id formated\n\n";
    print "l\t\tBrowse all addresses\n\n";
    print "h\t\tHelp\n\n";
    print "s text\t\tSearch text in all addresses and browse these address\n\n";
    print "q, quit, exit\tShutdown and save.\n\n";
}

sub listById{
    my ($curId) = @_;
    my $realId = $curId - 1;
    if (${$addressBook}->address_exists($realId)){
	print "ID:\t\t$curId\n";
	${$addressBook}->get_address($realId)->browse;
    }
}

sub appendAdress{
    my ($curId) = @_;
    print "The adress you want to change:\n\n";
    listById($curId);
    $curId--;
    if(${$addressBook}->address_exists($curId)){
	my $address = ${$addressBook}->get_address($curId);
	while (1){
	    print "(appendAddress) ";
	    chomp($input = <stdin>);
	    if($input eq "") {redo;}
	    if($input eq "."){last;};
	    if($input =~ ":"){
		my($key, $val)  = split(":",$input);
		$address->entry_field($key, $val);
	    }
	}
    }
}

sub deleteById{
    my ($curId) = @_;
    $curId--;
    if(${$addressBook}->address_exists($curId)){
	${$addressBook}->get_address($curId)->browse;
	print "Address deleted!\n";
	${$addressBook}->delete_address($curId);
    }
}

sub searchText{
    my ($searchText) = @_;
    ${$addressBook}->search_Text($searchText);
}

=pod

=head1 Name

Addressmangementsystem - Just a small mangementsystem

=head1 

=head1 Usage

F<cli.pl>

=head1

=head1 Helptext

=over 

=item

e = Add a new address:
	Form: 'key:value'
	Last item form: '.key:value'

=item

a id = Change or add an adress item: 
	Form:'key:value'
	Last item with: '.key:value'

=item

d id = Delete address on this id

=item

l id = Browse address on the given id formated

=item

l = Browse all addresses

=item

h = Help

=item

s text = Search text in all addresses and browse these address

=back

=head1

=cut
