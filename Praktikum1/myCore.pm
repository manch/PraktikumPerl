package myCore;

sub new {
    my ($class_name) = @_;
    my ($self) = {};

    bless ($self,$class_name);
    $self->{'_created'} = 1;
    return $self;
}

sub numberOk{
    my ($self, $number) = @_;
    my $anzahl;
    my @array;
    @array = split(//,$number);
    $anzahl = @array;
    if ($anzahl ne 4){
	return 0;
    }
    if (@array[0] == @array[1]){
	return 0;
    }
    elsif (@array[0] == @array[2]){
	return 0;
    }
    elsif (@array[0] == @array[3]){
	return 0;
    }
    elsif (@array[1] == @array[2]){
	return 0;
    }
    elsif (@array[1] == @array[3]){
	return 0;
    }
    elsif (@array[2] == @array[3]){
	return 0;
    }
    return 1;
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
    if ($self->numberOk($userValue)){
	$i = 0;
    }
    else{
	$i = 1;
    }
    while ($i){
	print "Wrong input\nYour number had to be four-digit without letters!\n\nTry again:\n";
	$userValue = <STDIN>;
	chomp $userValue;
	if ($self->numberOk($userValue)){
	    $i = 1;
	}
	else{
	    $i = 0
	}
    }
    return $userValue;
}
1;
