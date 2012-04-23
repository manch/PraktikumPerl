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
	print "Das ist append zu nn\n";
	print "(AdressVerwaltung) ";
	next;
    }
    elsif ($inputArray[0] eq "d"){
	print "Das löscht nn\n";
	print "(AdressVerwaltung) ";
	next;
    }
    elsif ($inputArray[0] eq "l"){
	
	listById($inputArray[1]);
	print "(AdressVerwaltung) ";
	next;
    }
    elsif ($inputArray[0] eq "s"){
	print "such test ... in allen\n";
	print "(AdressVerwaltung) ";
	next;
    }
}

sub newAdress{
    print "(newAdress) ";
    $id += 1;
    
    while (<stdin>){
	chomp($input = $_);
	if(substr($input,0,1) eq "."){
	    my @tmp = split(//,$input);
	    shift @tmp;
	    $input = join "",@tmp;
	    @inputArray = split(":",$input);
	    $adresses{"ID"}{"$id"}{"$inputArray[0]"} = "$inputArray[1]";
	    last;
	}
	@inputArray = split(":",$input);
	$adresses{"ID"}{"$id"}{"$inputArray[0]"} = $inputArray[1];
	print "(newAdress) ";
    }
}

sub list{
    foreach my $k1 ( sort keys %adresses ) {
	foreach my $k2 ( sort keys %{$adresses{$k1}} ) {
	    foreach my $k3 ( sort keys %{$adresses{$k1}{$k2}} ) {
		print "$k1\t$k2\t$k3\t$adresses{$k1}{$k2}{$k3}\n";
	    }
	    print "\n";
	}
    }
}

sub browseHelp{
    print "e\tAdd a new adress\n\tForm: 'key:value'\n\tLast item form: '.key:value'\n\n";
    print "a id\tChange or add an adress item: 'key:value'\n\n";
    print "d id\tDelete adress on this id\n\n";
    print "l id\tBrowse adress on the given id formated\n\n";
    print "l\tBrowse all adresses\n\n";
    print "h\tHelp\n\n";
    print "s text\tSearch text in all adresses and browse these adresses\n\n";
}

sub listById{
    my ($curId) = @_;
    foreach my $k1 ( sort keys %adresses ) {
	foreach my $k2 ( sort keys %{$adresses{$k1}} ) {
	    if ($curId eq $k2){
		foreach my $k3 ( sort keys %{$adresses{$k1}{$k2}} ) {
		    print "$k1\t$k2\t$k3\t$adresses{$k1}{$k2}{$k3}\n";
		}
	    }
	    print "\n";
	}
    }
}
