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
    my $anzahl;
    my @array;
    @array = split(//,$number);
    $anzahl = @array;
    @array = uniq @array;
    return ((true { defined($_) } @array) != 4);
}

sub getBulls{
    my ($self,$randomNumber,$userValue) = @_;
    my @random;
    my @users;
    @random = split(//,$randomNumber);
    @users = split(//,$userValue);
    my $i;
    my $counter;
    $counter = 0;
    for( $i = 0 ; $i < 4 ; $i++ ){
	if (@random[$i] eq @users[$i]){
	    $counter++;
	}
    }
    return $counter;
}

sub getCows{
    my ($self, $randomNumber, $userValue) = @_;
    my @random;
    my @users;
    @random = split(//,$randomNumber);
    @users = split(//,$userValue);
    my $i;
    my $j;
    my $counter;
    $counter = 0;
    for ( $i = 0 ; $i < 4 ; $i++){
	for ( $j = 0 ; $j < 4 ; $j++){
	    if($i != $j){
		if(@random[$i] eq @users[$j]){
		    $counter++;
		}
	    }
	}
    }
    return $counter;
}

sub getPlayerNumber{
    my ($self) = @_;
    my $userValue;
    $userValue = <STDIN>;
    chomp $userValue;
     while ($self->numberWrong($userValue)){
	print "Wrong input\nYour number had to be four-digit without the same letters!\n\nTry again:\n";
	$userValue = <STDIN>;
	chomp $userValue;
    }
    return $userValue;
}
1;
