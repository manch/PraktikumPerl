#!/opt/lampp/bin/perl
use warnings;
use strict;

use CGI;
use DBI;
use List::Util qw (max);

##
#    Funktioniert: l, l id, s text
#    ToDo:         e, a, d id
##

my $query = CGI->new;
my $id = 0;
my $dbh = DBI::->connect("dbi:SQLite:dbname=myAddManSys.db","","");
my $input;
my @inputArray;


print $query->header;
print $query->start_html('Address Management System'),
    $query->h1('Your Address Management System'),
    $query->start_form,
    "Insert your command ",$query->textfield('cmd'),
    
    $query->submit("Execute"),
    $query->end_form;


if ($query->param()) {
    
    print $query->a({href=>"index.pl"},"Back to main");
    $input = $query->param("cmd");
    if ($input eq "e"){
	newAdress();
    }
    elsif($input eq "l"){
	list();
    }
    else{
	@inputArray = split(" ", $input);
	if ($inputArray[0] eq "a"){
	    appendAdress($inputArray[1]);
	}
	elsif ($inputArray[0] eq "d"){
	    deleteById($inputArray[1]);
	}
	elsif ($inputArray[0] eq "l"){	
	    listById($inputArray[1]);
	}
	elsif ($inputArray[0] eq "s"){
	    searchText($inputArray[1]);
	}
    }
}else{
    print 
	$query->hr,
	$query->p,
	"e - Add a new address\n\n",
	$query->p,
	"a id - Change or add an adress item\n\n",
	$query->p,
	"d id - Delete address on this id\n\n",
	$query->p,
	"l id - Browse address on the given id formated\n\n",
	$query->p,
	"l - Browse all addresses\n\n",
	$query->p,
	"s text - Search text in all addresses and browse these address\n\n";
}


print $query->end_html;


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
	print 
	    $query->hr,
	    $query->p,
	    "ID:\t\t$row[0]\n",
	    $query->p,
	    "Name:\t\t$row[1]\n",
	    $query->p,
	    "Lastname:\t$row[2]\n";
	my @row2;
	my $sth2;
	$sth2 = $dbh->prepare("SELECT * FROM 'base_entry' WHERE id=$row[0]");
	$sth2->execute();
	while(@row2 = $sth2->fetchrow_array){
	    print 
		$query->p,
		"$row2[1]\t\t$row2[2]\n";
	}
	print $query->p;
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
	print 
	    $query->hr,
	    $query->p,
	    "ID:\t\t$row[0]\n",
	    $query->p,
	    "Name:\t\t$row[1]\n",
	    $query->p,
	    "Lastname:\t$row[2]\n";
	while(@row2 = $sth2->fetchrow_array){
	    print $query->p,"$row2[1]\t\t$row2[2]\n";
	}
    }
    print $query->p;
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
    my $delete = $dbh->prepare("DELETE FROM 'base_entry' WHERE id=$curId");
    $delete->execute;
    $delete->finish;
    $delete = $dbh->prepare("DELETE FROM 'base' WHERE id=$curId");
    $delete->execute;
    $delete->finish;
    #$dbh->do("DELETE FROM 'base_entry' WHERE id=$curId");
    #$dbh->do("DELETE FROM 'base' WHERE id=$curId");

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
