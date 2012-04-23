package myCore;
use strict;
use warnings;
use List::MoreUtils qw (uniq true all any);
use Data::Random qw (:all);

sub new {
    my ($class_name) = @_;
    my ($self) = {};

    bless ($self,$class_name);
    $self->{'_created'} = 1;
    return $self;
}

sub numberWrong{
    my ($self, $number) = @_;
    my @array = split(//,$number);
    my $anzahl = @array;
    @array = uniq @array;
    return ((true { defined($_) } @array) != 4);
}

sub getBulls{
    my ($self,$randomNumber,$userValue) = @_;
    my @random = split(//,$randomNumber);
    my @users = split(//,$userValue);
    my $counter = 0;
    for( 0..3 ){
	if ($random[$_] eq $users[$_]){
	    $counter++;
	}
    }
    return $counter;
}

sub getCows{
    my ($self, $randomNumber, $userValue) = @_;
    my @random = split(//,$randomNumber);
    my @users = split(//,$userValue);
    my $counter;
    $counter = 0;
    for my $i (0..$#users){
	if ((any { $users[$i] == $_ } @random) && ( $users[$i] != $random[$i]))
	{
	    ++$counter;
	}
    }
    return $counter;
}

sub getPlayerNumber{
    my ($self) = @_;
    chomp( my $userValue = <STDIN>);
    while ($self->numberWrong($userValue)){
	print "Wrong input\nYour number had to be four-digit without the same letters!\n\nTry again:\n";
	chomp ( $userValue = <STDIN>);
    }
    return $userValue;
}

sub getRandomNumber{
    my ($self) = @_;
    my @randomNumAr = rand_chars(set => [1..9], size=>4);
    return join "",@{randomNumAr};
}

sub isNotFinish{
    my ($self, $randomNumber, $userValue) = @_;
    my @random = split(//,$randomNumber);
    my @users = split(//,$userValue);
    return ! all { $random[$_] == $users[$_] } (0..$#users)
}

1;
