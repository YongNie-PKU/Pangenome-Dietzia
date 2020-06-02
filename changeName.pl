#!/usr/bin/perl -w
use strict;

my $num = 1;

while (<>) {
s/(*\|\).*$/$1&$num/ if(/^>/)
$num = $num + 1;
print;
}