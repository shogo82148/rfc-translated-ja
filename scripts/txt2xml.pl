#!/usr/bin/env perl

use v5.38;
use utf8;
use JSON qw(decode_json);
use Encode qw(encode_utf8 decode_utf8);

binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

my $number = $ARGV[0];

open my $buf, ">", \my $output or die "failed to open: $!";

sub slurp($file) {
    open my $fh, "<", $file or die "failed to open: $!";
    my $content = do { local $/; <$fh> };
    close $fh;
    return decode_utf8($content);
}

sub patch($input, $patch_file) {
    use File::Temp qw/ tempfile tempdir /;
    my $dir = tempdir( CLEANUP => 1 );
    my ($fh, $filename) = tempfile( DIR => $dir );
    print $fh encode_utf8($input);
    close($fh);

    system("patch -i $patch_file $filename > /dev/null 2>&1");
    return slurp($filename);
}

sub escape($s) {
    $s =~ s/&/&amp;/g;
    $s =~ s/</&lt;/g;
    $s =~ s/>/&gt;/g;
    $s =~ s/"/&quot;/g;
    return $s;
}

sub appendix_number($n) {
    my $a = "a";
    $a++ for 1..$n;
    return $a;
}

sub parse_section_name($s) {
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

sub parse_appendix_name($s) {
    unless($s =~ /^(?:(Appendix) )?([A-Z][.](?:\d+[.])*)\s+(.+)$/) {
        die "invalid appendix name: $s";
    }
    my $appendix = $1;
    my $number = $2;
    my $name = $3;

    $number =~ s/[.]$//; # 末尾のピリオドを削除
    my @numbers = split /[.]/, $number;
    my $slugified_name = lc($name =~ s/\s+/-/gr);
    return +{
        anchor => $slugified_name,
        pn => lc($appendix ? "section-appendix.$number" : "section-$number"),
        number => $number,
        level => scalar(@numbers),
        slugified_name => "name-$slugified_name",
        name => $name,
    };
}

sub parse_reference($s) {
    $s =~ s(^\[([A-Z][^\]\s]*)\] ([^"]*)"([^"]+)")();
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

sub parse_content($s) {
    if ($s =~ /^o /) {
        # リスト
        my @items = split m/^o /m, $s;
        shift @items; # 先頭は空文字列
        return {
            type => "ul",
            content => [map {escape($_ =~ s/\s*$//r)} @items],
        };
    }

    return {
        type => "t",
        content => parseT($s),
    };
}
sub parseT($s) {
    if ($s !~ /^\s*\+(?:-{3,}\+)+\s*$/m && $s =~ /^\s{2,}/) {
        # 整形済みテキスト
        my $ret = '';

        if ($s =~ s/^\s*Figure\s+(\d+):(.*)//) {
            # キャプションがあれば反映
            my $no = $1;
            my $caption = $2;
            $ret .= '<figure anchor="fig-'. $no . '" align="left" suppress-title="false" pn="figure-'. $no . '">' . "\n";
            $ret .= '<name slugifiedName="name-figure-' . $no . '">' . $caption .  "</name>\n";
            $ret .= '<artwork name="" type="" align="left" alt=""><![CDATA[' . "\n";
            $ret .= "$s\n";
            $ret .= ']]></artwork>' . "\n";
            $ret .= '</figure>' . "\n";
        } else {
            $ret .= '<artwork name="" type="" align="left" alt=""><![CDATA[' . "\n";
            $ret .= "$s\n";
            $ret .= ']]></artwork>' . "\n";
        }
        return $ret;
    }

    $s = escape($s);
    $s =~ s(((:?MUST|SHALL|SHOULD)(:?\sNOT)?|REQUIRED|(:?NOT\s)?RECOMMENDED|MAY|OPTIONAL))(<bcp14>$1</bcp14>)g;

    if ($s =~ /^\s*\+(?:-{3,}\+)+\s*$/m) {
        # 表のパース
        my $is_body = 0;
        my @thead;
        my @tbody;
        for my $row(split /\n/, $s) {
            if ($row =~ /^\s*\+(?:-{3,}\+)+\s*$/) {
                if (@thead) {
                    $is_body = 1;
                }
                next;
            }
            $row =~ s/^\s*\|//;
            $row =~ s/\|\s*$//;
            my @cells = split /\s*[|]\s*/, $row;
            if ($is_body) {
                if ($cells[0]) {
                    push @tbody, [@cells];
                } else {
                    # 一列目は見出し列として扱う
                    # 見出し列がカラの場合は、前の行のセルと結合
                    for my $i(0..$#cells) {
                        $tbody[-1][$i] .= ' ' . $cells[$i];
                    }
                }
            } else {
                if (@thead) {
                    # ヘッダーが複数行にまたがっている場合は、セルを結合
                    for my $i(0..$#cells) {
                        $thead[-1][$i] .= ' ' . $cells[$i];
                    }
                } else {
                    push @thead, [@cells];
                }
            }
        }

        # 表のレンダリング
        my $ret = '<table align="center">' . "\n";
        $ret .= '<thead>' . "\n";
        $ret .= '<tr>' . "\n";
        for my $row(@thead) {
            $ret .= '<tr>'. "\n";
            for my $cell(@$row) {
                $ret .= sprintf('<td align="left">%s</td>'."\n", $cell);
            }
            $ret .= '</tr>' . "\n";
        }
        $ret .= '</tr>' . "\n";
        $ret .= '</thead>' . "\n";
        $ret .= '<tbody>' . "\n";
        for my $row(@tbody) {
            $ret .= '<tr>'. "\n";
            for my $cell(@$row) {
                $ret .= sprintf('<td align="left">%s</td>'."\n", $cell);
            }
            $ret .= '</tr>' . "\n";
        }
        $ret .= '</tbody>' . "\n";
        $ret .= '</table>' . "\n";
        return $ret;
    }

    # 参照
    $s =~ s((?:Section\s+([0-9.]+)\s+of\s+)?\[([A-Z][^\]\s]*)\](?:,\s+Section\s+([0-9.]))?)(format_reference($1, $2, $3))eg;

    return $s;
}

sub format_reference($section_of, $ref, $section_comma) {
    if ($ref =~ /^RFC(\d+)$/) {
        # RFCのリンクはわかっているので、該当セクションへのリンクを生成する
        if ($section_of) {
            my $number = $1;
            my $link = sprintf("https://www.rfc-editor.org/rfc/rfc%d#section-%s", 0+$number, $section_of);
            return sprintf('<xref target="%s" section="%s" format="default" sectionFormat="of" derivedLink="%s" derivedContent="%s"/>', $ref, $section_of, $link, $ref);
        }
        if ($section_comma) {
            my $number = $1;
            my $link = sprintf("https://www.rfc-editor.org/rfc/rfc%d#section-%s", 0+$number, $section_comma);
            return sprintf('<xref target="%s" section="%s" format="default" sectionFormat="comma" derivedLink="%s" derivedContent="%s"/>', $ref, $section_comma, $link, $ref);
        }

        return sprintf('<xref target="%s" format="default" sectionFormat="of" derivedContent="%s"/>', $ref, $ref);
    }

    # リンクがわからないので、文字列にフォールバック
    if ($section_of) {
        return sprintf('Section %s of <xref target="%s" format="default" sectionFormat="of" derivedContent="%s"/>', $section_of, $ref, $ref);
    }
    if ($section_comma) {
        return sprintf('<xref target="%s" format="default" sectionFormat="comma" derivedContent="%s"/>, Section %s', $ref, $ref, $section_comma);
    }
    return sprintf('<xref target="%s" format="default" sectionFormat="of" derivedContent="%s"/>', $ref, $ref);
}

# セクションの目次を表示
sub handle_section_toc($section) {
    my $title = $section->{title};
    my $level = $title->{level};
    print $buf '  ' x ($level+4);
    print $buf '<li pn="section-toc.1-1.' . $title->{number} . '">' . "\n";

    print $buf '  ' x ($level+5);
    print $buf '<t indent="0" keepWithNext="true" pn="section-toc.1-1.' . $title->{number} . '.1">';
    print $buf '<xref derivedContent="' . $title->{number} . '" format="counter" sectionFormat="of" target="'. $title->{pn} .'"/>';
    print $buf '.  ';
    print $buf '<xref derivedContent="" format="title" sectionFormat="of" target="' . escape($title->{slugified_name}) .'">';
    print $buf escape($title->{name});
    print $buf '</xref>';
    print $buf "</t>\n";

    if (my @subsections = grep {$_->{type} =~ /^(?:section|appendix|references)$/} @{$section->{contents}}) {
        print $buf '  ' x ($level+5);
        print $buf '<ul bare="true" empty="true" indent="2" spacing="compact" pn="section-toc.1-1.' . $title->{number} . '.2">';
        print $buf "\n";
        for my $subsection(@subsections) {
            handle_section_toc($subsection);
        }
        print $buf '  ' x ($level+5);
        print $buf "</ul>\n";
    }

    print $buf '  ' x ($level+4);
    print $buf "</li>\n";
}

# セクションを表示
sub handle_section($section) {
    my $title = $section->{title};
    my $level = $title->{level};
    print $buf '  ' x ($level+1);
    print $buf '<section';
    print $buf ' anchor="' . escape($title->{anchor}) . '"';
    print $buf ' numbered="true" removeInRFC="false" toc="include"';
    print $buf ' pn="' . escape($title->{pn}) . '"';
    print $buf ">\n";

    # name
    print $buf '  ' x ($level+2);
    printf $buf '<name slugifiedName="%s">%s</name>', escape($title->{slugified_name}), escape($title->{name});
    print $buf "\n";

    # contents
    my $index = 0;
    for my $content(@{$section->{contents}}) {
        if ($content->{type} eq "t") {
            $index++;
            print $buf '  ' x ($level+2);
            print $buf '<t indent="0" pn="' . escape("$title->{pn}-$index") . '">';
            print $buf $content->{content};
            print $buf "</t>\n";
        } elsif ($content->{type} eq "section" || $content->{type} eq "appendix") {
            handle_section($content);
        } elsif ($content->{type} eq "ul") {
            $index++;
            print $buf '  ' x ($level+2);
            print $buf '<ul bare="false" empty="false" indent="3" spacing="normal" pn="' . escape("$title->{pn}-$index") . '">' . "\n";
            my $no = 0;
            for my $item(@{$content->{content}}) {
                $no++;
                print $buf '  ' x ($level+3);
                print $buf '<li pn="' . escape("$title->{pn}-$index.$no") . '">';
                print $buf $item;
                print $buf "</li>\n";
            }
            print $buf '  ' x ($level+2);
            print $buf "</ul>\n";
        } else {
            die "unknown content type: $content->{type}";
        }
    }

    print $buf '  ' x ($level+1);
    say $buf '</section>';
}

sub handle_references($references) {
    my $title = $references->{title};
    my $level = $title->{level};
    print $buf '  ' x ($level+1);
    say $buf '<references pn="' . escape($title->{pn}) . '">';
    print $buf '  ' x ($level+2);
    printf $buf '<name slugifiedName="%s">%s</name>', escape($title->{slugified_name}), escape($title->{name});
    print $buf "\n";

    for my $content(@{$references->{contents}}) {
        if ($content->{type} eq 'reference') {
            print $buf '  ' x ($level+2);
            print $buf '<reference';
            print $buf ' anchor="' . escape($content->{anchor}) . '"';
            if ($content->{target}) {
                print $buf ' target="' . escape($content->{target}) . '"';
            }
            print $buf ' quoteTitle="true"';
            print $buf ' derivedAnchor="' . escape($content->{anchor}) . '"';
            print $buf ">\n";

            print $buf '  ' x ($level+3);
            print $buf "<front>\n";

            # タイトル
            print $buf '  ' x ($level+4);
            printf $buf "<title>%s</title>\n", escape($content->{title});

            # 公開日
            if ($content->{year}) {
                print $buf '  ' x ($level+4);
                printf $buf "<date year=\"%s\"", escape($content->{year});
                if ($content->{month}) {
                    printf $buf " month=\"%s\"", escape($content->{month});
                }
                print $buf "/>\n";
            }

            print $buf '  ' x ($level+3);
            print $buf "</front>\n";

            # series Info
            for my $info(@{$content->{series_info}}) {
                print $buf '  ' x ($level+3);
                printf $buf "<seriesInfo name=\"%s\">%s</seriesInfo>\n", escape($info->{name}), escape($info->{value});
            }

            print $buf '  ' x ($level+2);
            print $buf "</reference>\n";
        } elsif ($content->{type} eq 'references') {
            handle_references($content);
        } else {
            die "unknown content type: $content->{type}";
        }
    }

    print $buf '  ' x ($level+1);
    print $buf "</references>\n";
}

my $content = slurp("src/rfcs/rfc$number.txt");
my $meta = decode_json(slurp("src/rfcs/rfc$number.json"));

# ページ毎に分割
my @contents = split /\n\f\n/, $content;

# 各ページの先頭と末尾には、ページヘッダー・フッターが入っているので削除
my $last_indent = 0;
for my $c(@contents) {
    $c =~ s/^.*\n//; # ヘッダー削除
    $c =~ s/\n.*$//; # フッター削除
    $c =~ s/([^.\s])\s*$/$1/; # 末尾の空白を削除
    $c =~ s/^\n*//; # 先頭の改行を削除

    $c =~ s/^((?:Appendix\s)?[A-Z0-9]+[.](?:[0-9]+[.])*\s\s)/\n$1/; # 章番号の前には改行が必要
    $c =~ s/^Acknowledgements/\nAcknowledgements/; # 謝辞の前には改行が必要
    $c =~ s/^(\s{3}o\s{2,})/\n$1/; # リストの前には改行が必要
    if ($c =~ /^(\s+)/) {
        my $current_indent = length($1);
        if ($current_indent != $last_indent) {
            # インデントが変わったら改行
            $c = "\n" . $c;
        }
    }
    if ($c =~ /\n+(\s+).*$/) {
        $last_indent = length($1);
    }
}

$content = join "\n", @contents;
$content =~ s/^(\s*\n)*//; # 先頭の空行を削除
$content =~ s/(\s*\n)*$//; # 末尾の空行を削除
$content =~ s/\n\s*\n(\s*\n)*/\n\n/g; # 連続する空行を1行にまとめる

# 二ページに連続する表を結合
$content =~ s/[|]\n\n *[|]/|\n|/g;

# 空行区切りで分割
@contents = split /\n\n/, $content;

shift @contents; # ドキュメントヘッダーを削除
shift @contents; # タイトルを削除

# 特別なセクション
my @abstract = ();
my @status_of_this_memo = ();
my @copyright_notice = ();
my @table_of_contents = ();
my @acknowledgements = ();

# 参考文献
my $references_root = {
    type => "references_root",
    parent => undef,
    level => 0,
};
my $current_references = undef;

# 付録
my $appendix_root = {
    type => "appendix-root",
    parent => undef,
    level => 0,
};
my $current_appendix = undef;

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
            my $title = parse_section_name($context);
            my $new_references = +{
                type => "references",
                title => $title,
                contents => [],
            };
            if ($title->{level} == 1) {
                push @{$references_root->{contents}}, $new_references;
                $new_references->{parent} = $references_root;
            } else {
                my $parent = $current_references;
                while ($parent->{title}->{level} >= $title->{level}) {
                    $parent = $parent->{parent};
                }
                push @{$parent->{contents}}, $new_references;
                $new_references->{parent} = $parent;
            }
            $current_references = $new_references;
        } elsif ($context =~ /^(?:Appendix )?[A-Z][.]/) {
            my $title = parse_appendix_name($context);
            my $new_appendix = +{
                type => "appendix",
                title => $title,
                contents => [],
            };
            if ($title->{level} == 1) {
                push @{$appendix_root->{contents}}, $new_appendix;
                $new_appendix->{parent} = $appendix_root;
            } else {
                my $parent = $current_appendix;
                while ($parent->{title}->{level} >= $title->{level}) {
                    $parent = $parent->{parent};
                }
                push @{$parent->{contents}}, $new_appendix;
                $new_appendix->{parent} = $parent;
            }
            $current_appendix = $new_appendix;
        } elsif ($context =~ /^\d+[.]/) {
            my @contents = split /\s\s\s/, $context, 2;
            my $title = parse_section_name(shift @contents);
            my $new_section = +{
                type => "section",
                title => $title,
                contents => [],
            };
            if (my $content = shift @contents) {
                $content =~ s/^\s\s\s//mg;
                push @{$new_section->{contents}}, parse_content($content);
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
    } elsif ($context =~ /Status of This Memo/i) {
        push @status_of_this_memo, parseT($content);
    } elsif ($context eq "Copyright Notice") {
        push @copyright_notice, parseT($content);
    } elsif ($context eq "Table of Contents") {
        push @table_of_contents, $content;
    } elsif ($context eq "Acknowledgements") {
        push @acknowledgements, parseT($content);
    } elsif ($context =~ /^Author(?:'s|s|s')? Address(?:es)?$/) {
        # 解析が大変なのでギブアップ
    } elsif ($context =~ /(:?Normative\s|Informative\s)?References/) {
        $content =~ s/\s+/ /g;
        push @{$current_references->{contents}}, parse_reference($content);
    } elsif ($context =~ /^(?:Appendix )?[A-Z][.]/) {
        push @{$current_appendix->{contents}}, parse_content($content);
    } elsif ($context =~ /^\d+[.]/) {
        push @{$current_section->{contents}}, parse_content($content);
    }
}

# RFCタグ
say $buf "<?xml version='1.0' encoding='utf-8'?>";
print $buf '<rfc xmlns:xi="http://www.w3.org/2001/XInclude" version="3"';
if ($meta->{draft}) {
    print $buf ' docName="' . escape($meta->{draft}) . '"';
}
print $buf ' indexInclude="true"';
print $buf ' number="' . ($meta->{doc_id} =~ s/^RFC//r) . '"';
say $buf ' symRefs="true" tocDepth="3" tocInclude="true" xml:lang="en">';

# LINKタグ
if ($meta->{draft}) {
    print $buf '  <link href="https://datatracker.ietf.org/doc/';
    print $buf escape($meta->{draft});
    say $buf '" rel="prev"/>';
}
if ($meta->{doi}) {
    print $buf '<link href="https://dx.doi.org/';
    print $buf escape(lc($meta->{doi}));
    say $buf '" rel="alternate"/>';
}

# FRONT
say $buf "  <front>";
say $buf "    <title>" . escape($meta->{title}) . "</title>";
say $buf '    <seriesInfo name="RFC" value="' . ($meta->{doc_id} =~ s/^RFC//r) . '" stream="IETF"/>';

if ($meta->{pub_date} && $meta->{pub_date} =~ /(?:(January|February|March|April|May|June|July|August|September|October|November|December) )?(\d+)/) {
    my $month = $1;
    my $year = $2;
    print $buf '    <date year="' . $year . '"';
    if ($month) {
        print $buf ' month="' . $month . '"';
    }
    print $buf "/>\n";
}

# Abstract
say $buf '    <abstract pn="section-abstract">';
for my $i(0..$#abstract) {
    say $buf '      <t indent="0" pn="section-abstract-' . ($i + 1) . '">' . escape($abstract[$i]) . '</t>';
}
say $buf '    </abstract>';

# boilerplate
say $buf "    <boilerplate>";

# Status of This Memo
if (@status_of_this_memo) {
    say $buf '      <section anchor="status-of-memo" numbered="false" removeInRFC="false" toc="exclude" pn="section-boilerplate.1">';
    say $buf '        <name slugifiedName="name-status-of-this-memo">Status of This Memo</name>';
    for my $i(0..$#status_of_this_memo) {
        say $buf '        <t indent="0" pn="section-boilerplate.1.' . ($i + 1) . '">' . $status_of_this_memo[$i] . '</t>';
    }
    say $buf '      </section>';
}

# Copyright
if (@copyright_notice) {
    say $buf '      <section anchor="copyright" numbered="false" removeInRFC="false" toc="exclude" pn="section-boilerplate.2">';
    say $buf '        <name slugifiedName="name-copyright-notice">Copyright Notice</name>';
    for my $i(0..$#copyright_notice) {
        say $buf '        <t indent="0" pn="section-boilerplate.2-' . ($i + 1) . '">' . $copyright_notice[$i] . '</t>';
    }
    say $buf '      </section>';
}
say $buf "    </boilerplate>";

# 目次
if (@table_of_contents) {
    say $buf '    <toc>';
    say $buf '      <section anchor="toc" numbered="false" removeInRFC="false" toc="exclude" pn="section-toc.1">';
    say $buf '        <name slugifiedName="name-table-of-contents">Table of Contents</name>';
    say $buf '        <ul bare="true" empty="true" indent="2" spacing="compact" pn="section-toc.1-1">';
    for my $section(@{$root->{contents}}) {
        handle_section_toc($section);
    }
    for my $references(@{$references_root->{contents}}) {
        handle_section_toc($references);
    }
    for my $section(@{$appendix_root->{contents}}) {
        handle_section_toc($section);
    }
    if (@acknowledgements) {
        my $num = appendix_number(scalar(@{$appendix_root->{contents}}));
        say $buf '          <li pn="section-toc.1-1.' . $num . '">';
        say $buf '            <t indent="0" pn="section-toc.1-1.' . $num . '.1"><xref derivedContent="" format="none" sectionFormat="of" target="section-appendix.' . $num . '"/><xref derivedContent="" format="title" sectionFormat="of" target="name-acknowledgements">Acknowledgements</xref></t>';
        say $buf '          </li>';
    }
    say $buf '      </ul>';
    say $buf '      </section>';
    say $buf '    </toc>';
}

# End of Front
say $buf "  </front>";

# MIDDLE
say $buf '  <middle>';
for my $section(@{$root->{contents}}) {
    handle_section($section);
}
say $buf '  </middle>';

# BACK
say $buf '  <back>';
# References
for my $references(@{$references_root->{contents}}) {
    handle_references($references);
}

# Appendix
for my $appendix(@{$appendix_root->{contents}}) {
    handle_section($appendix);
}

# Acknowledgements
if (@acknowledgements) {
    my $num = appendix_number(scalar(@{$appendix_root->{contents}}));
    print $buf '    <section anchor="acknowledgements" numbered="false" removeInRFC="false" toc="exclude" pn="section-appendix.' . $num . '">' . "\n";
    print $buf '      <name slugifiedName="name-acknowledgements">Acknowledgements</name>'. "\n";
    for my $i(0..$#acknowledgements) {
        say $buf '        <t indent="0" pn="section-appendix.' . $num . '-' . ($i + 1) . '">' . $acknowledgements[$i] . '</t>';
    }
    say $buf '      </section>';
}

say $buf '  </back>';

# end of RFC
say $buf "</rfc>";

close $buf;

unless ($ENV{RFC_NO_PATCH}) {
    my $patch_file = "src/patches/rfc$number.patch";
    if (-f $patch_file) {
        $output = patch($output, $patch_file)
    }
}

print $output;
