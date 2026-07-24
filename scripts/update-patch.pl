#!/usr/bin/env perl

use v5.44;
use File::Temp qw(tempdir);

my $dir = tempdir(CLEANUP => 1);

my @patch_list = glob("./src/patches/rfc*.patch");
my @rfc_numbers = map { m(/rfc([0-9]+)\.patch\z); $1 } @patch_list;
@rfc_numbers = sort { $b <=> $a } @rfc_numbers;

for my $number(@rfc_numbers) {
    local $ENV{RFC_NO_PATCH} = 1;
    say "Generating patch for RFC $number...";
    system("./scripts/txt2xml.pl $number > $dir/rfc$number.xml");
    system("diff -u --label '' --label '' $dir/rfc$number.xml ./src/en/rfc$number.xml > ./src/patches/rfc$number.patch");
}
