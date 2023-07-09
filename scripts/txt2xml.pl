#!/usr/bin/env perl

use v5.36;
use utf8;
use JSON qw(decode_json);

binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

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
        number => $number,
        level => scalar(@numbers),
        slugified_name => "name-$slugified_name",
        name => $name,
    };
}

sub parseReference($s) {
    $s =~ s(^\[([^]]+)\] ([^"]*)"([^"]+)")();
    my $anchor = $1;
    my $authors = $2;
    my $title = $3;

    $s =~ s((?:, (?:(January|February|March|April|May|June|July|August|September|October|November|December) )?(\d+))?(?:, <([^>]*)>)?[.]$)();
    my $month = $1;
    my $year = $2;
    my $target = $3;

    my @series_info;
    for my $info(split /,/, $s) {
        $info =~ s/^\s+//;
        $info =~ s/\s+$//;
        if ($info =~ m(^(DOI|RFC|BCP|Internet-Draft|STD|IEEE|ISO/IEC|ITU-T Recommendation|FIPS PUB) (.*)$)) {
            push @series_info, +{
                name => $1,
                value => $2,
            };
        }
    }

    return +{
        type => "reference",
        anchor => $anchor,
        title => $title,
        month => $month,
        year => $year,
        target => $target,
        series_info => [@series_info],
    };
}

# セクションの目次を表示
sub handle_section_toc($section) {
    my $title = $section->{title};
    my $level = $title->{level};
    print '  ' x ($level+4);
    print '<li pn="section-toc.1-1.' . $title->{number} . '">' . "\n";

    print '  ' x ($level+5);
    print '<t indent="0" keepWithNext="true" pn="section-toc.1-1.' . $title->{number} . '.1">';
    print '<xref derivedContent="' . $title->{number} . '" format="counter" sectionFormat="of" target="'. $title->{pn} .'"/>';
    print '.  ';
    print '<xref derivedContent="" format="title" sectionFormat="of" target="' . escape($title->{slugified_name}) .'">';
    print escape($title->{name});
    print '</xref>';
    print "</t>\n";

    if (my @subsections = grep {$_->{type} eq 'section'} @{$section->{contents}}) {
        print '  ' x ($level+5);
        print '<ul bare="true" empty="true" indent="2" spacing="compact" pn="section-toc.1-1.' . $title->{number} . '.2">';
        print "\n";
        for my $subsection(@subsections) {
            handle_section_toc($subsection);
        }
        print '  ' x ($level+5);
        print "</ul>\n";
    }

    print '  ' x ($level+4);
    print "</li>\n";
}

# セクションを表示
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

sub handle_references($references) {
    my $title = $references->{title};
    my $level = $title->{level};
    print '  ' x ($level+1);
    say '<references pn="' . escape($title->{pn}) . '">';
    print '  ' x ($level+2);
    printf '<name slugifiedName="%s">%s</name>', escape($title->{slugified_name}), escape($title->{name});
    print "\n";

    for my $content(@{$references->{contents}}) {
        if ($content->{type} eq 'reference') {
            print '  ' x ($level+2);
            print '<reference';
            print ' anchor="' . escape($content->{anchor}) . '"';
            if ($content->{target}) {
                print ' target="' . escape($content->{target}) . '"';
            }
            print ' quoteTitle="true"';
            print ' derivedAnchor="' . escape($content->{anchor}) . '"';
            print ">\n";

            print '  ' x ($level+3);
            print "<front>\n";

            # タイトル
            print '  ' x ($level+4);
            printf "<title>%s</title>\n", escape($content->{title});

            # 公開日
            if ($content->{year}) {
                print '  ' x ($level+4);
                printf "<date year=\"%s\"", escape($content->{year});
                if ($content->{month}) {
                    printf " month=\"%s\"", escape($content->{month});
                }
                print "/>\n";
            }

            print '  ' x ($level+3);
            print "</front>\n";

            # series Info
            for my $info(@{$content->{series_info}}) {
                print '  ' x ($level+3);
                printf "<seriesInfo name=\"%s\">%s</seriesInfo>\n", escape($info->{name}), escape($info->{value});
            }

            print '  ' x ($level+2);
            print "</reference>\n";
        } elsif ($content->{type} eq 'references') {
            handle_references($content);
        } else {
            die "unknown content type: $content->{type}";
        }
    }

    print '  ' x ($level+1);
    print "</references>\n";
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
my @acknowledgements = ();

# 参考文献
my $referencesRoot = {
    type => "referencesRoot",
    parent => undef,
    level => 0,
};
my $current_references = undef;

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

        if ($context =~ /(:?Normative\s|Informative\s)?References/) {
            my $title = parseSectionName($context);
            my $new_references = +{
                type => "references",
                title => $title,
                contents => [],
            };
            if ($title->{level} == 1) {
                push @{$referencesRoot->{contents}}, $new_references;
                $new_references->{parent} = $referencesRoot;
            } else {
                my $parent = $current_references;
                while ($parent->{title}->{level} >= $title->{level}) {
                    $parent = $parent->{parent};
                }
                push @{$parent->{contents}}, $new_references;
                $new_references->{parent} = $parent;
            }
            $current_references = $new_references;
        } elsif ($context =~ /^\d+[.]/) {
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
    } elsif ($context eq "Acknowledgements") {
        push @acknowledgements, $content;
    } elsif ($context =~ /^Author(?:'s|s|s')? Address(?:es)?$/) {
        # 解析が大変なのでギブアップ
    } elsif ($context =~ /(:?Normative\s|Informative\s)?References/) {
        $content =~ s/\s+/ /g;
        push @{$current_references->{contents}}, parseReference($content);
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

if ($meta->{pub_date} && $meta->{pub_date} =~ /(?:(January|February|March|April|May|June|July|August|September|October|November|December) )?(\d+)/) {
    my $month = $1;
    my $year = $2;
    print '    <date year="' . $year . '"';
    if ($month) {
        print ' month="' . $month . '"';
    }
    print "/>\n";
}

# Abstract
say '    <abstract pn="section-abstract">';
for my $i(0..$#abstract) {
    say '      <t indent="0" pn="section-abstract-' . ($i + 1) . '">' . escape($abstract[$i]) . '</t>';
}
say '    </abstract>';

# boilerplate
say "    <boilerplate>";

# Status of This Memo
if (@statusOfThisMemo) {
    say '      <section anchor="status-of-memo" numbered="false" removeInRFC="false" toc="exclude" pn="section-boilerplate.1">';
    say '        <name slugifiedName="name-status-of-this-memo">Status of This Memo</name>';
    for my $i(0..$#statusOfThisMemo) {
        say '        <t indent="0" pn="section-boilerplate.1.' . ($i + 1) . '">' . escape($statusOfThisMemo[$i]) . '</t>';
    }
    say '      </section>';
}

# Copyright
if (@copyrightNotice) {
    say '      <section anchor="copyright" numbered="false" removeInRFC="false" toc="exclude" pn="section-boilerplate.2">';
    say '        <name slugifiedName="name-copyright-notice">Copyright Notice</name>';
    for my $i(0..$#copyrightNotice) {
        say '        <t indent="0" pn="section-boilerplate.2-' . ($i + 1) . '">' . escape($copyrightNotice[$i]) . '</t>';
    }
    say '      </section>';
}
say "    </boilerplate>";

# 目次
say '    <toc>';
say '      <section anchor="toc" numbered="false" removeInRFC="false" toc="exclude" pn="section-toc.1">';
say '        <name slugifiedName="name-table-of-contents">Table of Contents</name>';
say '        <ul bare="true" empty="true" indent="2" spacing="compact" pn="section-toc.1-1">';
for my $section(@{$root->{contents}}) {
    handle_section_toc($section);
}
say '      </ul>';
say '      </section>';
say '    </toc>';

# End of Front
say "  </front>";

# MIDDLE
say '  <middle>';
for my $section(@{$root->{contents}}) {
    handle_section($section);
}
say '  </middle>';

# BACK
say '  <back>';
# References
for my $references(@{$referencesRoot->{contents}}) {
    handle_references($references);
}

# Acknowledgements
if (@acknowledgements) {
    print '    <section anchor="acknowledgements" numbered="false" removeInRFC="false" toc="exclude" pn="section-appendix.a">' . "\n";
    print '      <name slugifiedName="name-acknowledgements">Acknowledgements</name>'. "\n";
    for my $i(0..$#acknowledgements) {
        say '        <t indent="0" pn="section-appendix.a-' . ($i + 1) . '">' . escape($acknowledgements[$i]) . '</t>';
    }
    say '      </section>';
}

say '  </back>';

# end of RFC
say "</rfc>";

1;
