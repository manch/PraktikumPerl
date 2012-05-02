#!/usr/bin/perl
use warnings;
use strict;

print "(AdressVerwaltung) ";
    
my $input;
my $id=0;
my @inputArray;
my %adresses =();


while(<stdin>){
    
    chomp ($input = $_);
    
    if ($input eq "e"){
	newAdress();
	print "(AdressVerwaltung) ";
	next;
    }
    elsif($input eq "l"){
	list();
	print "(AdressVerwaltung) ";
	next;
    }
    elsif($input eq "h"){
	browseHelp();
	print "(AdressVerwaltung) ";
	next;
    }
    @inputArray = split(" ", $input);
    if ($inputArray[0] eq "a"){
	appendAdress($inputArray[1]);
	print "(AdressVerwaltung) ";
	next;
    }
    elsif ($inputArray[0] eq "d"){
	deleteById($inputArray[1]);
	print "(AdressVerwaltung) ";
	next;
    }
    elsif ($inputArray[0] eq "l"){	
	listById($inputArray[1]);
	print "(AdressVerwaltung) ";
	next;
    }
    elsif ($inputArray[0] eq "s"){
	searchText($inputArray[1]);
	print "(AdressVerwaltung) ";
	next;
    }
    if($input eq "exit"){
	last;
    }
    print "(AdressVerwaltung) ";

}

sub newAdress{
    print "(newAdress) ";
    #$id = scalar keys %adresses;
    $id += 1;
    while (<stdin>){
	chomp($input = $_);
	if(substr($input,0,1) eq "."){
	    my @tmp = split(//,$input);
	    shift @tmp;
	    $input = join "",@tmp;
	    @inputArray = split(":",$input);
	    $adresses{"$id"}{"$inputArray[0]"} = "$inputArray[1]";
	    last;
	}
	@inputArray = split(":",$input);
	$adresses{"$id"}{"$inputArray[0]"} = $inputArray[1];
	print "(newAdress) ";
    }
}

sub list{
    foreach my $k1 ( sort keys %adresses ) {
	print "ID\t$k1:\n";
	foreach my $k2 ( sort keys %{$adresses{$k1}} ) {
	    print "\t$k2\t$adresses{$k1}{$k2}\n";
	}
	print "\n";
    }
}

sub browseHelp{
    print "e\tAdd a new adress\n\tForm: 'key:value'\n\tLast item form: '.key:value'\n\n";
    print "a id\tChange or add an adress item: 'key:value'\n\tLast item with: '.key:value'\n\n";
    print "d id\tDelete adress on this id\n\n";
    print "l id\tBrowse adress on the given id formated\n\n";
    print "l\tBrowse all adresses\n\n";
    print "h\tHelp\n\n";
    print "s text\tSearch text in all adresses and browse these adresses\n\n";
}

sub listById{
    my ($curId) = @_;
    foreach my $k1 ( sort keys %adresses ) {
	if ($curId eq $k1){
	    foreach my $k2 ( sort keys %{$adresses{$k1}} ) {
		    print "$k1\t$k2\t$adresses{$k1}{$k2}\n";
	    }
	}
	    print "\n";
    }
}

sub appendAdress{
    my ($curId) = @_;
    print "The adress you want to change:\n\n";
    listById($curId);
    print "(appendAdress) ";
    while (<stdin>){
	chomp($input = $_);
	if(substr($input,0,1) eq "."){
	    my @tmp = split(//,$input);
	    shift @tmp;
	    $input = join "",@tmp;
	    @inputArray = split(":",$input);
	    foreach my $k1 ( sort keys %adresses ) {
		if($curId eq $k1){
		    foreach my $k2 ( sort keys %{$adresses{$k1}} ) {
			if ($k2 eq $inputArray[0]){
			    delete $adresses{$k1}{$k2};
			    $adresses{"$curId"}{"$inputArray[0]"}= $inputArray[1];
			}
			else{
			    $adresses{"$curId"}{"$inputArray[0]"}= $inputArray[1];
			}
		    }
		}
	    }
	    last;
	}
	@inputArray = split(":",$input);

	foreach my $k1 ( sort keys %adresses ) {
	    if($curId eq $k1){
		foreach my $k2 ( sort keys %{$adresses{$k1}} ) {
		    if ($k2 eq $inputArray[0]){
			delete $adresses{$k1}{$k2};
			$adresses{"$curId"}{"$inputArray[0]"}= $inputArray[1];
		    }
		    else{
			$adresses{"$curId"}{"$inputArray[0]"}= $inputArray[1];
		    }
		}
	    }
	}
	print "(appendAdress) ";
    }    
}

sub deleteById{
    my ($curId) = @_;
    foreach my $k1 ( sort keys %adresses ) {
	if ($curId eq $k1){
	    print "ID\t$k1:\n";
	    foreach my $k2 ( sort keys %{$adresses{$k1}} ) {
		    print "\t$k2\t$adresses{$k1}{$k2}\n";
		    delete $adresses{$k1}{$k2};
		    delete $adresses{$k1};
	    }
	    print "Deleted\n";
	}
    }
}

sub searchText{
    my ($searchText) = @_;
    foreach my $k1 ( sort keys %adresses ) {
	foreach my $k2 ( sort keys %{$adresses{$k1}} ) {
	    if($adresses{$k1}{$k2} =~ $searchText){
		listById($k1);
	    }
	}
	print "\n";
    }
}
