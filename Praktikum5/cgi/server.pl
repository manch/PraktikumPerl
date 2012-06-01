#!/usr/bin/perl
{
package MyWebServer;

use HTTP::Server::Simple::CGI;
use base qw(HTTP::Server::Simple::CGI);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use DBI;
use List::Util qw (max);


my %dispatch = (
    '/index' => \&resp_INDEX,
    '/navi' => \&resp_NAVI,
    '/addr' => \&resp_ADDR,
    '/text' => \&resp_TEXT,
    # ...
);
 
sub handle_request {
    my $self = shift;
    my $cgi  = shift;
    
    my $path = $cgi->path_info();
    my $handler = $dispatch{$path};
    
    if (ref($handler) eq "CODE") {
	print "HTTP/1.0 200 OK\r\n";
	$handler->($cgi);	
    } else {
	print "HTTP/1.0 404 Not found\r\n";
	print 	$cgi->header,
	    $cgi->start_html('Not found'),
	    $cgi->h1('Not found'),
	    $cgi->end_html;
    }
}
 
 
sub resp_ADDR
{
    $q = shift;   # CGI.pm object

    print $q->header();                    # create the HTTP header
    print $q->start_html( -target=>'ADDR'); 		# start the HTML
    {

    print $q->h1('Address');   	# level 1 header

    if(  defined $q->param('edit') ) {
	print $q->start_form(-action=>"addr", -target=>"ADDR");
	print "Name: ", $q->textfield(
	    -name=>'name',
	    -default=>'',
	    -override=>1,
	    -size=>50,
	    -maxlength=>50);
	print "Lastname: ", $q->textfield(
	    -name=>'lastname',
	    -default=>'',
	    -override=>1,
	    -size=>50,
	    -maxlength=>50);
	print $q->br;
	print "Add like:", $q->br, "key:value,key:value", $q->br;
	print $q->textarea (
	    -name=>'Text',
	    -default=>'',
	    -rows=>5,
	    -columns=>50);

	print $q->br;
	print $q->hidden('index', $q->param('Number'));
	print $q->submit(-name=>'saveEdit',
			 -value=>'Save');	
	print $q->end_form();
    }
    elsif (defined $q->param('new') ) {
	print $q->start_form(-action=>"addr", -target=>"ADDR");
	print "Name: ", $q->textfield(
	    -name=>'name',
	    -default=>'',
	    -override=>1,
	    -size=>50,
	    -maxlength=>50);
	print $q->br;
	print "Lastname: ", $q->textfield(
	    -name=>'lastname',
	    -default=>'',
	    -override=>1,
	    -size=>50,
	    -maxlength=>50);
	print $q->br;
	print "Add like:", $q->br, "key:value,key:value", $q->br;
	print $q->textarea (
	    -name=>'Text',
	    -default=>'',
	    -rows=>5,
	    -columns=>50);
	print $q->hidden('index', -1 );
	
	print $q->br;
	print $q->submit(-name=>'saveNew',
			 -value=>'Save');	
	print $q->end_form();
    }
    elsif (defined $q->param('delete') )
    {
	print $q->h2("Deleted this address" );
	listById($q->param('Number'));
	deleteById($q->param('Number'));
    }
    elsif (defined $q->param('saveEdit') ){
	appendAddress($q->param('index'), $q->param('name'), $q->param('lastname'), $q->param('Text') );
    }
    elsif (defined $q->param('saveNew') ){
	newAddress($q->param('name'), $q->param('lastname'),$q->param('Text'));
    }
    print $q->end_html;
    }# end the HTML
}

sub resp_NAVI
{
    $q = shift;   # CGI.pm object
    
    print $q->header(-target=>'NAVI');                    # create the HTTP header
    print $q->start_html('Navi'); 		# start the HTML
    {
	print $q->h1('Menue');        # level 1 header
	print $q->hr();
	print $q->start_form(-action=>"addr", -target=>"ADDR");
	print $q->textfield(-name=>'Number',
			    -default=>'1',
			    -override=>1,
			    -size=>10,
			    -maxlength=>10);
	print $q->submit(-name=>'new', -value=>'New');	
	print $q->submit(-name=>'edit',	-value=>'Edit');
	print $q->submit(-name=>'delete', -value=>'Delete');
	print $q->end_form();
	
	print $q->hr();
	print $q->start_form(-action=>"text", -target=>"TEXT");
	print $q->textfield(-name=>'SearchString',
			    -default=>'Search text',
			    -override=>1,
			    -size=>10,
			    -maxlength=>10);
	print $q->submit(-name=>'searchText', -value=>'Search');
	print $q->p;
	print $q->textfield(-name=>"searchId",
			    -default=>"Search Id",
			    -override=>1,
			    -size=>10,
			    -maxlength=>10);
	print $q->submit(-name=>'browseById', -value=>'Browse by id');
	print $q->submit(-name=>'print', -value=>'Browse all');	
	print $q->end_form();
	print $q->hr();	
    }    
    print $q->end_html;                  # end the HTML
}

sub resp_TEXT
{
    $q = shift;   # CGI.pm object
    
    print $q->header();                    # create the HTTP header
    print $q->start_html(-target=>'TEXT'); 		# start the HTML
    
    
    print $q->h1('Textbereich');   	# level 1 header
    
    if(defined $q->param('print') )
    {
	list();
    }
    elsif ( defined $q->param('searchText') )
    {
	searchText($q->param('SearchString'));
    }	
    elsif( defined $q->param('browseById') ){
	listById($q->param('searchId'));
    }
    print $q->end_html;                  # end the HTML
}
    
 
sub resp_INDEX
{
    my $q = shift;   # CGI.pm object
    
    my $border = 1;
    
    print $q->header();
    print q(<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">);
    print $q->html;
    print $q->head($q->title("Address Management System"));
    
    print $q->start_frameset({rows=>"50%,50%", frameborder=>"yes", border=>$border});
    
    print $q->start_frameset({cols=>"50%,50%", frameborder=>"yes", border=>$border});
    print $q->frame({name=>"NAVI", src=>"navi", border=>'1'});
    print $q->frame({name=>"ADDR", src=>"addr", border=>'1'});
    print $q->end_frameset();
    print $q->frame({name=>"TEXT", src=>"text", border=>'1'});
    print $q->end_frameset();
    
    print $q->end_html;
}


sub listById{
    my ($curId) = @_;
    my $dbh = DBI::->connect("dbi:SQLite:dbname=myAddManSys.db","","");
    my $sth = $dbh->prepare("SELECT * FROM 'base' WHERE id=$curId");
    my $sth2 = $dbh->prepare("SELECT * FROM 'base_entry' WHERE id=$curId");
    $sth->execute();
    $sth2->execute();
    my @row;
    my @row2;
    while(@row = $sth->fetchrow_array){
	print "ID:\t\t$row[0]",CGI->p;
	print "Name:\t\t$row[1]\n",CGI->p;
	print "Lastname:\t$row[2]\n",CGI->p;
	while(@row2 = $sth2->fetchrow_array){
	    print "$row2[1]:\t\t$row2[2]\n",CGI->p;
	}
    }
    print "\n";
    $dbh->disconnect;
}
 
sub list{
    my $dbh = DBI::->connect("dbi:SQLite:dbname=myAddManSys.db","","");
    my $sth = $dbh->prepare("SELECT * FROM 'base'");
    my @row;
    $sth->execute();
    while(@row = $sth->fetchrow_array){
	print "ID:\t\t$row[0]\n", CGI->p;
	print "Name:\t\t$row[1]\n", CGI->p;
	print "Lastname:\t$row[2]\n", CGI->p;
	my @row2;
	my $sth2;
	$sth2 = $dbh->prepare("SELECT * FROM 'base_entry' WHERE id=$row[0]");
	$sth2->execute();
	while(@row2 = $sth2->fetchrow_array){
	    print "$row2[1]:\t\t$row2[2]\n", CGI->p;
	}
	print CGI->hr;
    }
    $dbh->disconnect;
}

sub searchText{
    my ($searchText) = @_;
    my $dbh = DBI::->connect("dbi:SQLite:dbname=myAddManSys.db","","");
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
    $dbh->disconnect;
}


sub deleteById{
    my ($curId) = @_;
    my $dbh = DBI::->connect("dbi:SQLite:dbname=myAddManSys.db","",""); 
    $dbh->do("DELETE FROM 'base' WHERE id=$curId");
    $dbh->do("DELETE FROM 'base_entry' WHERE id=$curId");
    $dbh->disconnect;
}

sub newAddress{
    my ($name, $lastname, $keysnvalues) = @_;
    chomp($keysnvalues);
    $id = checkID();

    my $dbh = DBI::->connect("dbi:SQLite:dbname=myAddManSys.db","",""); 
    $dbh->do("INSERT INTO 'base' (id, name, lastname) VALUES ($id,'$name','$lastname')");
    if($keysnvalues =~ ","){
	my @entries = split(",",$keysnvalues);
	foreach my $entry (@entries){
	    if($entry =~ ":"){
		my ($key, $val) = split(":",$entry);
		$dbh->do("INSERT INTO 'base_entry' (id, key,value) VALUES ($id, '$key', '$val')");
	    }
	}
    }
    elsif($keysnvalues =~ ":"){
	my ($key, $val) = split(":",$keysnvalues);
	$dbh->do("INSERT INTO 'base_entry' (id, key,value) VALUES ($id, '$key', '$val')");
    }
    $dbh->disconnect;
}


sub checkID{
    my $dbh = DBI::->connect("dbi:SQLite:dbname=myAddManSys.db","",""); 
    my $sth = $dbh->prepare("SELECT id FROM base");
    my @row;
    my @tmp=(0);
    $sth->execute();
    while (@row = $sth->fetchrow_array){
	push(@tmp,$row[0]);
    }
    $dbh->disconnect;
    return ((max @tmp)+1);
}


sub appendAddress{
    my ($curId, $name, $lastname, $keysnvalues) = @_;
    chomp($keysnvalues);
    my $dbh = DBI::->connect("dbi:SQLite:dbname=myAddManSys.db","",""); 
    my $insert_update;
    if($name ne ""){
	$insert_update = $dbh->prepare("UPDATE 'base' SET name=? WHERE id=$curId");
	$insert_update->execute($name);
	$insert_update->finish;
    }
    if($lastname ne ""){
	$insert_update = $dbh->prepare("UPDATE 'base' SET lastname=? WHERE id=$curId");
	$insert_update->execute($lastname);
	$insert_update->finish;
    }
    if($keysnvalues ne ""){
	my $sth = $dbh->prepare("SELECT key FROM 'base_entry' WHERE id=$curId");
	$sth->execute;
	my $updated = 0;
	if($keysnvalues =~ ","){
	    my @entries = split(",",$keysnvalues);
	
	    while(my @row = $sth->fetchrow_array){
		foreach my $entry (@entries){
		    my ($key, $val) = split(":",$entry);
		    if($row[0] eq $key){
			$insert_update = $dbh->prepare("UPDATE 'base_entry' SET value=? WHERE id=$curId AND key='$key'");
			$insert_update->execute($val);
			$insert_update->finish;
			$updated = 1;
		    }
		}
	    } 
	}else{
	    if($keysnvalues =~ ":"){
		while(my @row = $sth->fetchrow_array){
		    my ($key, $val) = split(":",$keysnvalues);
		    if($row[0] eq $key){
			$insert_update = $dbh->prepare("UPDATE 'base_entry' SET value=? WHERE id=$curId AND key='$key'");
			$insert_update->execute($val);
			$insert_update->finish;
			$updated = 1;
		    }
		}
	    }   
	}
    	if($updated == 0){
	    $insert_update = $dbh->prepare("INSERT INTO 'base_entry' (id, key, value) VALUES ($curId, '$key', '$val')");
	    $insert_update->execute;
	}
    }
    $dbh->disconnect;
}


} 
 
# start the server on port 8080
my $pid = MyWebServer->new(8080)->background();
print "Use 'kill $pid' to stop server.\n";
