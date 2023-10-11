#!/usr/bin/env perl

use v5.38;

my @rfc_list = glob("./src/en-raw/rfc*.xml");
my @rfc_numbers = map { m(/rfc([0-9]+)\.xml\z); $1 } @rfc_list;
@rfc_numbers = sort { $b <=> $a } @rfc_numbers;

for my $number(@rfc_numbers) {
    system("diff -u ./src/en-raw/rfc$number.xml ./src/ja/rfc$number.xml > ./src/patches/rfc$number.patch");
}
