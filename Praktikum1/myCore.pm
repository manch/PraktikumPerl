package myCore;
use List::MoreUtils qw (uniq true);
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
    for(0..3 ){
	if (@random[$_] eq @users[$_]){
	    $counter++;
	}
    }
    return $counter;
}

sub getCows{
    my ($self, $randomNumber, $userValue) = @_;
    my @random = split(//,$randomNumber);
    my @users = split(//,$userValue);
    my $i, $counter;
    $counter = 0;
    for (0..3){
	$i = $_;
	for (0..3){
	    if( ( $i != $_ ) && ( @random[$i] eq @users[$_] ) ){
		$counter++;
	    }
	}
    }
    return $counter;
}

sub getPlayerNumber{
    my ($self) = @_;
    my $userValue = <STDIN>;
    chomp $userValue;
    while ($self->numberWrong($userValue)){
	print "Wrong input\nYour number had to be four-digit without the same letters!\n\nTry again:\n";
	$userValue = <STDIN>;
	chomp $userValue;
    }
    return $userValue;
}
1;
