#!/usr/bin/env perl

use v5.44;
use utf8;
use strict;
use FindBin;

sub main() {
    my $dir = "$FindBin::Bin/../src/ja";
    while (my $file = glob "$dir/*.xml") {
        say STDERR "Updating $file";
        update($file);
    }
}

sub update($file) {
    my $content = slurp($file);

    # 目次見出しの「Table of Contents」は翻訳し忘れが多いので「目次」に置換する
    $content =~ s(<name(\s+)slugifiedName="name-table-of-contents">\s*Table\s+of\s+Contents\s*</name>)(<name${1}slugifiedName="name-table-of-contents">目次</name>)g;

    my %slugs = ();
    # <tt> などのインライン要素を含む見出しも対象にする（リンク要素 <xref> と <eref> を含む見出しは除く）
    while ($content =~ m(<name\s+slugifiedName="([^"]*)">((?:[^<]|<(?!/?[xe]ref\b|/name>))*)</name>)g) {
        my $slug = $1;
        my $name = $2;
        # 英語の目次と同じく、目次には <bcp14> タグを含めない
        $name =~ s(</?bcp14\b[^>]*>)()g;
        $slugs{$slug} = $name;
    }

    for my $slug(keys %slugs) {
        my $name = $slugs{$slug};
        $content =~ s(<xref(\s+([^>]*\s+)?)target="\Q$slug\E">(?:[^<]|<(?!/?xref\b))*</xref>)(<xref${1}target="$slug">$name</xref>)g;
    }
    write_file($file, $content);
}

sub slurp($file) {
    open my $fh, "<:encoding(UTF-8)", $file or die "failed to open: $!";
    my $content = do { local $/; <$fh> };
    close $fh;
    return $content;
}

sub write_file($file, $content) {
    my $tmp = "$file.tmp$$";
    open my $fh, ">:encoding(UTF-8)", $tmp or die "failed to open: $!";
    print $fh $content;
    close $fh;
    rename $tmp, $file;
}

main();
