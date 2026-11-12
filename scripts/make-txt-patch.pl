#!/usr/bin/env perl

# TXT 形式の RFC について、手で直した src/en/rfcN.xml と
# scripts/txt2xml.pl の素の出力との差分を src/patches/rfcN.patch に保存し、
# パッチを当てた txt2xml.pl の出力が src/en/rfcN.xml を再現できることを確認します。
#
# usage: scripts/make-txt-patch.pl <rfc-number>

use v5.44;
use utf8;
use File::Temp qw(tempdir);
use File::Compare qw(compare);

my $number = $ARGV[0];
die "usage: $0 <rfc-number>\n" unless defined $number && $number =~ /\A[0-9]+\z/;

my $txt = "src/rfcs/rfc$number.txt";
my $en = "src/en/rfc$number.xml";
my $patch = "src/patches/rfc$number.patch";
die "$txt does not exist.\n" unless -f $txt;
die "$en does not exist. Run scripts/txt2xml.pl --no-patch -o $en $number first.\n" unless -f $en;

my $dir = tempdir(CLEANUP => 1);

# パッチを当てない素の出力
system("./scripts/txt2xml.pl", "--no-patch", "-o", "$dir/raw.xml", $number) == 0
    or die "failed to run scripts/txt2xml.pl: $?\n";

my $status = system("diff -u --label '' --label '' $dir/raw.xml $en > $patch");
if ($status == -1 || ($status >> 8) > 1) {
    die "failed to run diff: $?\n";
}
say "Wrote $patch";

# Makefile と同じ手順で src/en/rfcN.xml が再現できるか確認する
system("./scripts/txt2xml.pl", "-o", "$dir/patched.xml", $number) == 0
    or die "failed to run scripts/txt2xml.pl: $?\n";
if (compare("$dir/patched.xml", $en) != 0) {
    die "scripts/txt2xml.pl $number with $patch does not reproduce $en.\n";
}
say "OK: scripts/txt2xml.pl $number reproduces $en";
