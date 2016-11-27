#!/usr/bin/perl

use CGI::Carp qw(fatalsToBrowser);
use CGI qw/:cgi :form escapeHTML/;
use Encode;
use JSON::PP;
use Storable qw(lock_store lock_nstore lock_retrieve);
use Apache2::RequestRec ();
use Apache2::Const ();

use strict;
use utf8;
use List::Util qw(shuffle);

my $ids_ref = lock_retrieve("/home/sugar/data/products_ids.sto");
my @ids = @$ids_ref;

srand();

my @shuffle = shuffle(@ids);

my $id = pop(@shuffle);

print STDERR "sugar_random.pl - " . scalar(@ids) . " products - id: $id\n";
		my $r = shift;

		$r->headers_out->set(Location =>"/$id");
		$r->headers_out->set(Pragma => "no-cache");
		$r->headers_out->set("Cache-control" => "no-cache");
		$r->status(302);  
		return 302;

