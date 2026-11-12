#!/usr/bin/env perl

use v5.44;
use utf8;

use JSON::PP;

sub generate_makefile(@rfc_numbers) {
    open my $fh, ">:encoding(utf8)", "Makefile" or die "failed to open: %!";
    say $fh ".DELETE_ON_ERROR:";
    say $fh "";
    say $fh ".PHONY: all";
    say $fh "all: \\\n", join " \\\n", map { "\tdocs/rfc$_.html" } @rfc_numbers;
    say $fh "";

    my @txt2xml_rfcs = ();
    for my $number(@rfc_numbers) {
        say $fh "docs/rfc$number.html: src/en/rfc$number.xml src/rfcs/rfc$number.json src/ja/rfc$number.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js";
        say $fh "\tscripts/xml2html.py $number";
        if (-f "src/rfcs/rfc$number.xml") {
            say $fh "src/en/rfc$number.xml: src/rfcs/rfc$number.xml";
            say $fh "\tcp \$< \$\@";
        } else {
            say $fh "src/en/rfc$number.xml: src/rfcs/rfc$number.txt src/rfcs/rfc$number.json scripts/txt2xml.pl src/patches/rfc$number.patch";
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

sub slurp_utf8($path) {
    open my $fh, "<:encoding(utf8)", $path or die "failed to open $path: $!";
    my $content = do { local $/; <$fh> };
    close($fh);
    return $content;
}

sub unescape_xml($text) {
    my %entities = (amp => '&', lt => '<', gt => '>', quot => '"', apos => "'");
    $text =~ s{&(?:#x([0-9a-fA-F]+)|#([0-9]+)|(amp|lt|gt|quot|apos));}{
        defined $1 ? chr(hex $1) : defined $2 ? chr($2) : $entities{$3}
    }ge;
    return $text;
}

sub escape_html($text) {
    $text =~ s/&/&amp;/g;
    $text =~ s/</&lt;/g;
    $text =~ s/>/&gt;/g;
    return $text;
}

# normalizes a title for docs/index.html, the same as scripts/register-rfc.py.
# U+2011 (NON-BREAKING HYPHEN) and U+2060 (WORD JOINER) in the RFC XML only control line breaks,
# and they get in the way of searching the index.
sub normalize_title($title) {
    $title =~ s/\x{2011}/-/g;
    $title =~ s/\x{2060}//g;
    $title =~ s/\s+/ /g;
    $title =~ s/\A //;
    $title =~ s/ \z//;
    return $title;
}

# returns the text of <front><title> in the XML file
sub read_xml_title($path) {
    my $content = slurp_utf8($path);
    $content =~ m{<front\b.*?<title\b[^>]*>(.*?)</title>}s or die "title not found in $path";
    my $title = $1;
    $title =~ s/<[^>]*>//g;
    return normalize_title(unescape_xml($title));
}

# the English title is taken from the original XML.
# RFCs only in TXT use the title in the JSON metadata,
# which scripts/txt2xml.pl writes into src/en/rfcN.xml.
sub get_en_title($number) {
    return read_xml_title("src/rfcs/rfc$number.xml") if -f "src/rfcs/rfc$number.xml";

    my $meta = JSON::PP->new->decode(slurp_utf8("src/rfcs/rfc$number.json"));
    return normalize_title($meta->{title} // '');
}

sub get_ja_title($number) {
    return read_xml_title("src/ja/rfc$number.xml");
}

sub generate_index(@rfc_numbers) {
    open my $fh, ">:encoding(utf8)", "docs/index.html" or die "failed to open: %!";
    print $fh <<__EOF__;
<!DOCTYPE html>
<html>
    <head>
        <title>RFC日本語訳</title>
        <meta charset="utf-8">
        <meta name="viewport" content="initial-scale=1.0">
<style type="text/css">\@import url(https://fonts.googleapis.com/css2?family=BIZ+UDPGothic:wght\@400;700&family=Noto+Sans+Mono&display=swap);

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
        my $title_ja = escape_html(get_ja_title($number));
        my $title_en = escape_html(get_en_title($number));
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
