#!/usr/bin/env perl

use v5.36;

use JSON qw(decode_json);

sub generate_makefile(@rfc_numbers) {
    open my $fh, ">", "Makefile" or die "failed to open: %!";
    say $fh ".PHONY: all";
    say $fh "all: \\\n", join " \\\n", map { "\tdocs/rfc$_.html" } @rfc_numbers;
    say $fh "";

    my @txt2xml_rfcs = ();
    for my $number(@rfc_numbers) {
        say $fh "docs/rfc$number.html: src/en/rfc$number.xml src/ja/rfc$number.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js";
        say $fh "\tscripts/xml2html.py $number";
        if (-f "src/rfcs/rfc$number.xml") {
            say $fh "src/en/rfc$number.xml: src/rfcs/rfc$number.xml";
            say $fh "\tcp \$< \$\@";
        } else {
            say $fh "src/en/rfc$number.xml: src/rfcs/rfc$number.txt scripts/txt2xml.pl src/patches/rfc$number.patch";
            say $fh "\tscripts/txt2xml.pl $number > \$\@";
            push @txt2xml_rfcs, $number;
        }
    }

    say $fh "";
    say $fh ".PHONY: update-english";
    say $fh "update-english:";
    for my $number(@txt2xml_rfcs) {
        say $fh "\tscripts/txt2xml.pl $number > src/ja/rfc$number.xml";
    }

    say $fh "";
    say $fh ".PHONY: update-toc";
    say $fh "update-toc:";
    say $fh "\tscripts/update-toc.pl";
    close($fh);
}

sub get_en_title($number) {
    open my $fh, "<", "src/rfcs/rfc$number.json" or die "failed to open: $!";
    my $content = do { local $/; <$fh> };
    close($fh);

    my $meta = decode_json($content);
    my $title = $meta->{title};
    $title =~ s/\s+$//;
    return $title
}

sub get_ja_title($number) {
    open my $fh, "<", "src/ja/rfc$number.xml" or die "failed to open: $!";
    my $title = "";
    while(<$fh>) {
        if (m(<title[^>]*>([^<]+)</title>)) {
            $title = $1;
            last;
        }
    }
    close($fh);
    return $title;
}

sub generate_index(@rfc_numbers) {
    open my $fh, ">", "docs/index.html" or die "failed to open: %!";
    print $fh <<__EOF__;
<!DOCTYPE html>
<html>
    <head>
        <title>RFC日本語訳</title>
        <meta charset="utf-8">
        <meta name="viewport" content="initial-scale=1.0">
<style type="text/css">\@import url(https://fonts.googleapis.com/css2?family=BIZ+UDPGothic:wght@400;700&family=Noto+Sans+Mono&display=swap);

\@viewport {
  zoom: 1;
  width: extend-to-zoom;
}

body {
  margin: 1.5em auto;
  color: #222;
  background-color: #fff;
  font-size: 16px;
  font-family: "BIZ UDPGothic", sans-serif;
  line-height: 1.6;
  scroll-behavior: smooth;
}
</style>
    </head>
    <body>
    <h1>RFC日本語訳</h1>
    <p>Copyright (c) <a href="https://github.com/shogo82148">ICHINOSE Shogo(\@shogo82148)</a> Licensed by CC BY-SA 3.0</p>
    <ul>
__EOF__

    for my $number(@rfc_numbers) {
        my $title_ja = get_ja_title($number);
        my $title_en = get_en_title($number);
        print $fh <<__EOF__;
        <li><a href="rfc$number.html">RFC $number $title_ja</a>
        (原文: <a href="https://www.rfc-editor.org/rfc/rfc$number">$title_en</a>)
__EOF__
    }

    print $fh <<__EOF__;
    </ul>
    </body>
</html>
__EOF__
    close($fh);
}

my @rfc_list = glob("./src/ja/rfc*.xml");
my @rfc_numbers = map { m(/rfc([0-9]+)\.xml\z); $1 } @rfc_list;
@rfc_numbers = sort { $b <=> $a } @rfc_numbers;

generate_makefile(@rfc_numbers);
generate_index(@rfc_numbers);
