#!/usr/bin/perl
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';

my $file = 'C:/Users/Pc/Desktop/budbaza/js/data.js';
open my $fh, '<:utf8', $file or die $!;
my $content = do { local $/; <$fh> };
close $fh;

my %groups = (
    "Лента битумна"      => [3877,3879,3881,3883,3885,3887,3889,3891,3893,3895,3897,3899,3901,3903,3905,3907,3909,3911,5561],
    "Стрейч"             => [4030,4032,4034,4036,4038],
    "Скотч"              => [4005,4007,4134,4136,3873,3875,4003,3948,3950,3952,3954,3999,4001],
    "Скотч двосторонній" => [4128,4130,4132],
    "Фум лента"          => [3913,3915,3917],
);

my %id_to_group;
for my $g (keys %groups) {
    for my $id (@{$groups{$g}}) {
        $id_to_group{$id} = $g;
    }
}

my $count = 0;
$content =~ s/(\{id:(\d+),[^}]+?subcat:"Скотч, стрічки та плівка",)(meta:)/
    do {
        my $id = $2;
        if ($id_to_group{$id}) {
            $count++;
            "$1subsubcat:\"$id_to_group{$id}\",$3"
        } else {
            "$1$3"
        }
    }
/ge;

open my $out, '>:utf8', $file or die $!;
print $out $content;
close $out;

print "Done. Added subsubcat to $count products.\n";
