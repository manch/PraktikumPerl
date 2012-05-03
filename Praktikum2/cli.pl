#!/usr/bin/perl
use warnings;
use strict;

    
my $input;
my $id=0;
my @inputArray;
my %addresses =();


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
    if($input eq "exit"){
	last;
    }
}

sub newAdress{
    #$id = scalar keys %adresses;
    $id += 1;
    while (1){
	print "(newAdress) ";
	chomp($input = <stdin>);
	if(substr($input,0,1) eq "."){
	    my @tmp = split(//,$input);
	    shift @tmp;
	    $input = join "",@tmp;
	    @inputArray = split(":",$input);
	    $addresses{"$id"}{"$inputArray[0]"} = "$inputArray[1]";
	    last;
	}
	@inputArray = split(":",$input);
	$addresses{"$id"}{"$inputArray[0]"} = $inputArray[1];
	#print "(newAdress) ";
    }
}

sub list{
    foreach my $k1 ( sort keys %addresses ) {
	print "ID\t$k1:\n";
	foreach my $k2 ( sort keys %{$addresses{$k1}} ) {
	    print "\t$k2\t$addresses{$k1}{$k2}\n";
	}
	print "\n";
    }
}

sub browseHelp{
    print "e\tAdd a new address\n\tForm: 'key:value'\n\tLast item form: '.key:value'\n\n";
    print "a id\tChange or add an adress item: 'key:value'\n\tLast item with: '.key:value'\n\n";
    print "d id\tDelete address on this id\n\n";
    print "l id\tBrowse address on the given id formated\n\n";
    print "l\tBrowse all addresses\n\n";
    print "h\tHelp\n\n";
    print "s text\tSearch text in all addresses and browse these address\n\n";
}

sub listById{
    my ($curId) = @_;
    foreach my $k1 ( sort keys %addresses ) {
	if ($curId eq $k1){
	    print "ID\t$k1:\n";
	    foreach my $k2 ( sort keys %{$addresses{$k1}} ) {
		    print "\t$k2\t$addresses{$k1}{$k2}\n";
	    }
	}
	    print "\n";
    }
}

sub appendAdress{
    my ($curId) = @_;
    print "The adress you want to change:\n\n";
    listById($curId);
    while (1){
	print "(appendAddress) ";
	chomp($input = <stdin>);
	if(substr($input,0,1) eq "."){
	    my @tmp = split(//,$input);
	    shift @tmp;
	    $input = join "",@tmp;
	    @inputArray = split(":",$input);
	    foreach my $k1 ( sort keys %addresses ) {
		if($curId eq $k1){
		    foreach my $k2 ( sort keys %{$addresses{$k1}} ) {
			if ($k2 eq $inputArray[0]){
			    delete $addresses{$k1}{$k2};
			    $addresses{"$curId"}{"$inputArray[0]"}= $inputArray[1];
			}
			else{
			    $addresses{"$curId"}{"$inputArray[0]"}= $inputArray[1];
			}
		    }
		}
	    }
	    last;
	}
	@inputArray = split(":",$input);

	foreach my $k1 ( sort keys %addresses ) {
	    if($curId eq $k1){
		foreach my $k2 ( sort keys %{$addresses{$k1}} ) {
		    if ($k2 eq $inputArray[0]){
			delete $addresses{$k1}{$k2};
			$addresses{"$curId"}{"$inputArray[0]"}= $inputArray[1];
		    }
		    else{
			$addresses{"$curId"}{"$inputArray[0]"}= $inputArray[1];
		    }
		}
	    }
	}
    }    
}

sub deleteById{
    my ($curId) = @_;
    foreach my $k1 ( sort keys %addresses ) {
	if ($curId eq $k1){
	    print "ID\t$k1:\n";
	    foreach my $k2 ( sort keys %{$addresses{$k1}} ) {
		    print "\t$k2\t$addresses{$k1}{$k2}\n";
		    delete $addresses{$k1}{$k2};
	    }
	    delete $addresses{$k1};
	    print "Deleted\n";
	}
    }
}

sub searchText{
    my ($searchText) = @_;
    foreach my $k1 ( sort keys %addresses ) {
	foreach my $k2 ( sort keys %{$addresses{$k1}} ) {
	    if($addresses{$k1}{$k2} =~ $searchText){
		listById($k1);
	    }
	}
    }
}
