#!/usr/bin/perl
use warnings;
use strict;
use myAddressBook;
use myAddress;
use DBI;
use List::Util qw (max);

my $id = 0;
my $dbh = DBI::->connect("dbi:SQLite:dbname=myAddManSys.db","","");
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

$dbh->disconnect;

sub newAdress{
    $id = checkID();
    print "(newAdress) Enter your name: ";
    chomp (my $name = <stdin>);
    
    print "(newAdress) Enter your lastname: ";
    chomp (my $lastname = <stdin>);
    $dbh->do("INSERT INTO 'base' (id, name, lastname) VALUES ($id,'$name','$lastname')");
    
    while (1){
	print "(newAdress) ";
	chomp($input = <stdin>);
	if($input eq "") {redo;}
	if($input eq "."){last;};
	if($input =~ ":"){
	    my($key, $val) = split(":",$input);
	    $dbh->do("INSERT INTO 'base_entry' (id, key,value) VALUES ($id, '$key', '$val')");
	}
    }
}

sub list{
    my $sth = $dbh->prepare("SELECT * FROM 'base'");
    my @row;
    $sth->execute();
    while(@row = $sth->fetchrow_array){
	print "ID:\t\t$row[0]\n";
	print "Name:\t\t$row[1]\n";
	print "Lastname:\t$row[2]\n";
	my @row2;
	my $sth2;
	$sth2 = $dbh->prepare("SELECT * FROM 'base_entry' WHERE id=$row[0]");
	$sth2->execute();
	while(@row2 = $sth2->fetchrow_array){
	    print "$row2[1]\t\t$row2[2]\n";
	}
	print "\n";
    }
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
    my $sth = $dbh->prepare("SELECT * FROM 'base' WHERE id=$curId");
    my $sth2 = $dbh->prepare("SELECT * FROM 'base_entry' WHERE id=$curId");
    $sth->execute();
    $sth2->execute();
    my @row;
    my @row2;
    while(@row = $sth->fetchrow_array){
	print "ID:\t\t$row[0]\n";
	print "Name:\t\t$row[1]\n";
	print "Lastname:\t$row[2]\n";
	while(@row2 = $sth2->fetchrow_array){
	    print "$row2[1]\t\t$row2[2]\n";
	}
    }
    print "\n";
}

sub appendAdress{
    my ($curId) = @_;
    print "The adress you want to change:\n\n";
    listById($curId);
#    if(${$addressBook}->address_exists($curId)){
	#my $address = ${$addressBook}->get_address($curId);
	while (1){
	    print "(appendAddress) ";
	    chomp($input = <stdin>);
	    if($input eq "") {redo;}
	    if($input eq "."){last;};
	    if($input =~ ":"){
		my($key, $val)  = split(":",$input);
		my $insert_update;
		if($key eq "Name" or $key eq "Lastname"){
		    if($key eq "Name"){
			$insert_update = $dbh->prepare("UPDATE 'base' SET name=? WHERE id=$curId");
		    }else{
			$insert_update = $dbh->prepare("UPDATE 'base' SET lastname=? WHERE id=$curId");
		    }
		    $insert_update->execute($val);
		    $insert_update->finish;

		}else{
		    my $sth = $dbh->prepare("SELECT key FROM 'base_entry' WHERE id=$curId");
		    $sth->execute;
		    my $updated = 0;
		    while(my @row = $sth->fetchrow_array){
			if($row[0] eq $key){
			    $insert_update = $dbh->prepare("UPDATE 'base_entry' SET value=? WHERE id=$curId AND key='$key'");
			    $insert_update->execute($val);
			    $insert_update->finish;
			    $updated = 1;
			}
		    } 
		    if($updated == 0){
			$insert_update = $dbh->prepare("INSERT INTO 'base_entry' (id, key, value) VALUES ($curId, '$key', '$val')");
			$insert_update->execute;
		    }
		    
		}
		
	    }
	}
#    }
}

sub deleteById{
    my ($curId) = @_;
    $dbh->do("DELETE FROM 'base' WHERE id=$curId");
    $dbh->do("DELETE FROM 'base_entry' WHERE id=$curId");
}

sub searchText{
    my ($searchText) = @_;
    my $sth = $dbh->prepare("SELECT * FROM 'base'");
    $sth->execute;
    my @row;
    while(@row = $sth->fetchrow_array){
	if($row[1] =~ $searchText or $row[2] =~ $searchText){
	    listById($row[0]);
	}else{
	    my $sth2 = $dbh->prepare("SELECT * FROM 'base_entry' WHERE id=$row[0]");
	    $sth2->execute;
	    my @row2;
	    while(@row2 = $sth2->fetchrow_array){
		if($row2[2] =~ $searchText){
		    listById($row2[0]);
		}
	    }
	}
    }
}

sub checkID{
    my $sth = $dbh->prepare("SELECT id FROM base");
    my @row;
    my @tmp=(0);
    $sth->execute();
    while (@row = $sth->fetchrow_array){
	push(@tmp,$row[0]);
    }
    return ((max @tmp)+1);
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
