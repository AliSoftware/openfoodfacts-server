#!/bin/sh

cd /home/off/cgi
./remove_empty_products.pl
./compute_missions.pl
./export_database.pl

