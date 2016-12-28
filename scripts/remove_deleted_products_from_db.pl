#!/usr/bin/perl

use CGI::Carp qw(fatalsToBrowser);

use Modern::Perl '2012';
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


# Get a list of all products


my $cursor = $products_collection->query({})->fields({ code => 1 });;
my $count = $cursor->count();
	
	print STDERR "$count products to update\n";
	
	while (my $product_ref = $cursor->next) {
        
		
		my $code = $product_ref->{code};
		my $path = product_path($code);
		
		# print STDERR "updating product $code\n";
		
		$product_ref = retrieve_product($code);
		
		if (not defined $product_ref) {
			print STDERR "cannot load product $code\n";
			my $product_ref = retrieve("$data_root/products/$path/product.sto");
			if (defined $product_ref) {
				print STDERR "deleted : $product_ref->{deleted} - _id : $product_ref->{_id}\n";
				$products_collection->remove({"code" => $code});
						my $err = $database->last_error();
		use Data::Dumper;
		print STDERR Dumper($err);
				# store_product($product_ref, "desindex deleted product");
			}
		}
		
		# index_product($product_ref);

		# Store

		# store("$data_root/products/$path/product.sto", $product_ref);		
		# $products_collection->save($product_ref);
	}

exit(0);

