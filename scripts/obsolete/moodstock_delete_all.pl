#!/usr/bin/perl

use CGI::Carp qw(fatalsToBrowser);

use strict;
use utf8;

use ProductOpener::Config qw/:all/;
use ProductOpener::Store qw/:all/;
use ProductOpener::Index qw/:all/;
use ProductOpener::Display qw/:all/;
use ProductOpener::Tags qw/:all/;
use ProductOpener::Users qw/:all/;
use ProductOpener::Images qw/:all/;
use ProductOpener::Lang qw/:all/;
use ProductOpener::Mail qw/:all/;
use ProductOpener::Products qw/:all/;
use ProductOpener::Food qw/:all/;
use ProductOpener::Ingredients qw/:all/;
use ProductOpener::Images qw/:all/;


use CGI qw/:cgi :form escapeHTML/;
use URI::Escape::XS;
use Storable qw/dclone/;
use Encode;
use JSON;
use MIME::Base64;


# Get a list of all products



	use HTTP::Request::Common;
	use LWP::UserAgent;
	use LWP::Authen::Digest;

	# Settings
	my $key = "6boshzcjfsqyxmnl9znd";
	my $secret = "ZunCQ56gcp53GhZb";

	# Boilerplate
	my $browser = LWP::UserAgent->new();
	$browser->credentials("api.moodstocks.com:80","Moodstocks API",$key,$secret);
	my $ep = "http://api.moodstocks.com/v2";
	
	my $url = "$ep/stats/refs";
	my $response = $browser->request(HTTP::Request->new("GET", $url));
	print "stats -> url: $url\nreponse -> " . $response->content . "\n";	
	
	my $content = $response->content;
	#  {"count":44,"ids":["fairtrade","bioab","bioeurope","carbone","fairtrade2","domaine-de-l-echauguette","Montagny-1er-cru-2008",
	#$content =~ s/\\/\\/g;
	
	my @ids = split(/"/, $content);
	
	foreach my $id (@ids) {
		
		next if $id =~ /,|:|\[|\]/;
		next if $id eq 'count';
		next if $id eq 'ids';
		
		$id =~ s/\\n/\n/g;
		
		print "deleting id: $id\n";
		my $response = $browser->request(HTTP::Request->new("DELETE","$ep/ref/$id"));
		print "response -> " . $response->content . "\n";	
	
	
	
	}
		

exit(0);

