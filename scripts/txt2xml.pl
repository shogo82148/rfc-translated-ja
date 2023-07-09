#!/usr/bin/env perl

use v5.36;
use utf8;
use JSON qw(decode_json);

my $number = $ARGV[0];

sub slurp($file) {
    open my $fh, "<", $file or die "failed to open: $!";
    my $content = do { local $/; <$fh> };
    close $fh;
    return $content;
}

sub escape($s) {
    $s =~ s/&/&amp;/g;
    $s =~ s/</&lt;/g;
    $s =~ s/>/&gt;/g;
    $s =~ s/"/&quot;/g;
    return $s;
}

sub parseSectionName($s) {
    unless($s =~ /^((?:\d+[.])+)\s+(.+)$/) {
        die "invalid section name: $s";
    }
    my $number = $1;
    my $name = $2;

    $number =~ s/[.]$//; # 末尾のピリオドを削除
    my @numbers = split /[.]/, $number;
    my $slugified_name = lc($name =~ s/\s+/-/gr);
    return +{
        anchor => $slugified_name,
        pn => "section-$number",
        level => scalar(@numbers),
        slugified_name => "name-$slugified_name",
        name => $name,
    };
}

sub handle_section($section) {
    my $title = $section->{title};
    my $level = $title->{level};
    print '  ' x ($level+1);
    print '<section';
    print ' anchor="' . escape($title->{anchor}) . '"';
    print ' numbered="true" removeInRFC="false" toc="include"';
    print ' pn="' . escape($title->{pn}) . '"';
    print ">\n";

    # name
    print '  ' x ($level+2);
    printf '<name slugifiedName="%s">%s</name>', escape($title->{slugified_name}), escape($title->{name});
    print "\n";

    # contents
    my $index = 0;
    for my $content(@{$section->{contents}}) {
        if ($content->{type} eq "t") {
            $index++;
            print '  ' x ($level+2);
            print '<t indent="0" pn="' . escape("$title->{pn}-$index") . '">';
            my $content = escape($content->{content});

            # BCP 14のキーワードを置換
            $content =~ s(((:?MUST|SHALL|SHOULD)(:?\sNOT)?|REQUIRED|(:?NOT\s)?RECOMMENDED|MAY|OPTIONAL))(<bcp14>$1</bcp14>)g;

            print $content;
            print "</t>\n";
        } elsif ($content->{type} eq "section") {
            handle_section($content);
        } else {
            die "unknown content type: $content->{type}";
        }
    }

    print '  ' x ($level+1);
    say '</section>';
}

my $content = slurp("src/rfcs/rfc$number.txt");
my $meta = decode_json(slurp("src/rfcs/rfc$number.json"));

# ページ毎に分割
my @contents = split /\n\f\n/, $content;

# 各ページの先頭と末尾には、ページヘッダー・フッターが入っているので削除
@contents = map {
    my @lines = split /\n/, $_;
    pop @lines;
    shift @lines;
    join "\n", @lines;
} @contents;

$content = join "\n", @contents;
$content =~ s/^(\s*\n)*//; # 先頭の空行を削除
$content =~ s/(\s*\n)*$//; # 末尾の空行を削除
$content =~ s/\n\s*\n(\s*\n)*/\n\n/g; # 連続する空行を1行にまとめる

# 空行区切りで分割
@contents = split /\n\n/, $content;

shift @contents; # ドキュメントヘッダーを削除
shift @contents; # タイトルを削除

# 特別なセクション
my @abstract = ();
my @statusOfThisMemo = ();
my @copyrightNotice = ();
my @tableOfContents = ();
my @appendixes = ();

# 通常セクション
my $root = {
    type => "root",
    parent => undef,
    title => {
        anchor => "root",
        pn => "section-root",
        level => 0,
        slugified_name => "name-root",
        name => "root",
    },
    contents => [],
};
my $current_section = undef;

my $context = "";
for my $content(@contents) {
    if ($content !~ /^\s+/) {
        # 概要・目次・セクション等の開始
        $context = $content;

        if ($context =~ /^\d+[.]/) {
            my @contents = split /\s\s\s/, $context, 2;
            my $title = parseSectionName(shift @contents);
            my $new_section = +{
                type => "section",
                title => $title,
                contents => [],
            };
            if (my $content = shift @contents) {
                $content =~ s/^\s\s\s//mg;
                push @{$new_section->{contents}}, +{
                    type => "t",
                    content => $content,
                };
            }
            if ($title->{level} == 1) {
                push @{$root->{contents}}, $new_section;
                $new_section->{parent} = $root;
            } else {
                my $parent = $current_section;
                while ($parent->{title}->{level} >= $title->{level}) {
                    $parent = $parent->{parent};
                }
                $parent->{contents} = [] unless $parent->{contents};
                push @{$parent->{contents}}, $new_section;
                $new_section->{parent} = $parent;
            }
            $current_section = $new_section;
        }
        next;
    }

    # セクションの内容
    # 各行の先頭の空白を削除
    $content =~ s/^\s\s\s//mg;

    if ($context eq "Abstract") {
        push @abstract, $content;
    } elsif ($context eq "Status of This Memo") {
        push @statusOfThisMemo, $content;
    } elsif ($context eq "Copyright Notice") {
        push @copyrightNotice, $content;
    } elsif ($context eq "Table of Contents") {
        push @tableOfContents, $content;
    } elsif ($context =~ /^\d+[.]/) {
        push @{$current_section->{contents}}, {
            type => "t",
            content => $content,
        };
    }
}

# RFCタグ
say "<?xml version='1.0' encoding='utf-8'?>";
print '<rfc xmlns:xi="http://www.w3.org/2001/XInclude" version="3"';
if ($meta->{draft}) {
    print ' docName="' . escape($meta->{draft}) . '"';
}
print ' indexInclude="true"';
print ' number="' . ($meta->{doc_id} =~ s/^RFC//r) . '"';
say ' symRefs="true" tocDepth="3" tocInclude="true" xml:lang="en">';

# LINKタグ
if ($meta->{draft}) {
    print '  <link href="https://datatracker.ietf.org/doc/';
    print escape($meta->{draft});
    say '" rel="prev"/>';
}
if ($meta->{doi}) {
    print '<link href="https://dx.doi.org/';
    print escape(lc($meta->{doi}));
    say '" rel="alternate"/>';
}

# FRONT
say "  <front>";
say "    <title>" . escape($meta->{title}) . "</title>";
say '    <seriesInfo name="RFC" value="' . ($meta->{doc_id} =~ s/^RFC//r) . '" stream="IETF"/>';
# TODO: Author
# TODO: Date
# TODO: Area
# TODO: Workgroup

# Abstract
say '    <abstract pn="section-abstract">';
for my $i(0..$#abstract) {
    say '      <t indent="0" pn="section-abstract-' . ($i + 1) . '">' . escape($abstract[$i]) . '</t>';
}
say '    </abstract>';
say "  </front>";

# boilerplate
say "    <boilerplate>";

# Status of This Memo
say '      <section anchor="status-of-memo" numbered="false" removeInRFC="false" toc="exclude" pn="section-boilerplate.1">';
say '        <name slugifiedName="name-status-of-this-memo">Status of This Memo</name>';
for my $i(0..$#statusOfThisMemo) {
    say '        <t indent="0" pn="section-boilerplate.1.' . ($i + 1) . '">' . escape($statusOfThisMemo[$i]) . '</t>';
}
say '      </section>';

# Copyright
say '      <section anchor="copyright" numbered="false" removeInRFC="false" toc="exclude" pn="section-boilerplate.2">';
say '        <name slugifiedName="name-copyright-notice">Copyright Notice</name>';
for my $i(0..$#copyrightNotice) {
    say '        <t indent="0" pn="section-boilerplate.2.' . ($i + 1) . '">' . escape($copyrightNotice[$i]) . '</t>';
}
say '      </section>';
say "    </boilerplate>";

if (@tableOfContents) {
    # TODO: Table of Contents
    # say '    <toc>';
    # say '      <section anchor="toc" numbered="false" removeInRFC="false" toc="exclude" pn="section-toc.1">';
    # say '        <name slugifiedName="name-table-of-contents">Table of Contents</name>';

    # say '      </section>';
    # say '    </toc>';
}


# MIDDLE
say '  <middle>';
for my $section(@{$root->{contents}}) {
    handle_section($section);
}
say '  </middle>';

# BACK
say '  <back>';
say '  </back>';

# end of RFC
say "</rfc>";

1;