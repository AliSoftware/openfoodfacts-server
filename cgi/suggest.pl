#!/usr/bin/perl

# This file is part of Product Opener.
# 
# Product Opener
# Copyright (C) 2011-2015 Association Open Food Facts
# Contact: contact@openfoodfacts.org
# Address: 21 rue des Iles, 94100 Saint-Maur des Foss�s, France
# 
# Product Opener is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use Modern::Perl '2012';
use utf8;

use CGI::Carp qw(fatalsToBrowser);
use CGI qw/:cgi :form escapeHTML/;

use ProductOpener::Config qw/:all/;
use ProductOpener::Store qw/:all/;
use ProductOpener::Index qw/:all/;
use ProductOpener::Display qw/:all/;
use ProductOpener::Users qw/:all/;
use ProductOpener::Products qw/:all/;
use ProductOpener::Food qw/:all/;
use ProductOpener::Tags qw/:all/;

use CGI qw/:cgi :form escapeHTML/;
use URI::Escape::XS;
use Storable qw/dclone/;
use Encode;
use JSON::PP;

ProductOpener::Display::init();
use ProductOpener::Lang qw/:all/;

my $tagtype = param('tagtype');
my $string = decode utf8=>param('string');
my $term = decode utf8=>param('term');

my $search_lc = $lc;

if (defined param('lc')) {
	$search_lc = param('lc');
}

my $original_lc = $search_lc;

if ($term =~ /^(\w\w):/) {
	$search_lc = $1;
	$term = $';
}

my $stringid = get_fileid($string) . get_fileid($term);

my @tags = sort keys %{$translations_to{$tagtype}} ;

my @suggestions = ();

my $i = 0;

foreach my $canon_tagid (@tags) {

	next if not defined $translations_to{$tagtype}{$canon_tagid}{$search_lc};
	next if defined $just_synonyms{$tagtype}{$canon_tagid};
	my $tag = $translations_to{$tagtype}{$canon_tagid}{$search_lc};
	my $tagid = get_fileid($tag);
	next if $tagid !~ /^$stringid/;

	if (not ($search_lc eq $original_lc)) {
		$tag = $search_lc . ":" . $tag;
	}

	push @suggestions, $tag;
}


my $data =  encode_json(\@suggestions);
	
print "Content-Type: application/json; charset=UTF-8\r\nAccess-Control-Allow-Origin: *\r\n\r\n" . $data;	


