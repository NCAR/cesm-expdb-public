#!/usr/bin/env perl
#
use warnings;
use strict;
use CGI qw(:standard);
use DBI;
use DBD::mysql;
use Time::localtime;
use HTML::Entities;
use CGI::Carp qw(fatalsToBrowser warningsToBrowser); 
use Template;
use lib qw(.);
use lib "/var/www/html/csegdb/lib";
use config;
use lib "/var/www/html/experiments/public/lib";
use expPublic;

#------
# main 
#------
$ENV{PATH} = '';

my $req = CGI->new;
my %config = &getconfig;
my $dbname = $config{'dbname'};
my $dbhost = $config{'dbhost'};
my $dbuser = $config{'dbuser'};
my $dbpasswd = $config{'dbpassword'};
my $dsn = $config{'dsn'};

# initialize global item hash
my %item = ();
my $dbh = DBI->connect($dsn, $dbuser, $dbpasswd) or die "unable to connect to db: $DBI::errstr";
my @exps = getPublicExps($dbh);
my $vars = {
	exps => \@exps
};
$dbh->disconnect;
	


# set the template to use
my $tmplFile = '/var/www/html/experiments/public/templates/showPublicExps.tmpl';

# set the vars for the template
my $template = Template->new({
    ENCODING => 'utf8',
    ABSOLUTE => 1,
    INCLUDE_PATH => '/var/www/html/styles:/var/www/html/experiments/public/templates',
});

# render the template
$| = 1;
print "Content-type: text/html\n\n";
$template->process($tmplFile, $vars) || die ("Problem processing $tmplFile, ", $template->error());
exit;