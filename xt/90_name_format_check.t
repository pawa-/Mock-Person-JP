use strict;
use warnings;
use utf8;
use open qw/:utf8/;
use Mock::Person::JP;
use Test::More;

binmode Test::More->builder->$_ => ':utf8'
    for qw/output failure_output todo_output/;

subtest 'mei_female.tsv' => sub {
    open(my $fh, '<', 'share/mei_female.tsv') or die $!;
    chomp(my @lines = <$fh>);
    close($fh);

    for my $line (@lines)
    {
        my ($yomi, $mei) = split(/\t/, $line);

        like($yomi, qr/^[\p{InHiragana}\x{30FC}ゐゑヰヱ]+$/, 'yomi');
        like($mei,  qr/^[\p{Han}\p{InHiragana}\p{InKatakana}\x{30FC}〆]+$/, 'mei');
    }
};


subtest 'mei_male.tsv' => sub {
    open(my $fh, '<', 'share/mei_male.tsv') or die $!;
    chomp(my @lines = <$fh>);
    close($fh);

    for my $line (@lines)
    {
        my ($yomi, $mei) = split(/\t/, $line);

        like($yomi, qr/^[\p{InHiragana}\x{30FC}ゐゑヰヱ]+$/, 'yomi');
        like($mei,  qr/^[\p{Han}\p{InHiragana}\p{InKatakana}\x{30FC}〆]+$/, 'mei');
    }
};

subtest 'sei.tsv' => sub {
    open(my $fh, '<', 'share/sei.tsv') or die $!;
    chomp(my @lines = <$fh>);
    close($fh);

    for my $line (@lines)
    {
        my ($yomi, $sei) = split(/\t/, $line);

        like($yomi, qr/^[\p{InHiragana}\x{30FC}ゐゑヰヱ]+$/, 'yomi');
        like($sei,  qr/^[\p{Han}\p{InHiragana}\p{InKatakana}\x{30FC}〆]+$/, 'sei');
    }
};

done_testing;
