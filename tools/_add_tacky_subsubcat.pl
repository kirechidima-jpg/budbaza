#!/usr/bin/perl
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';

my $file = 'C:/Users/Pc/Desktop/budbaza/js/data.js';
open my $fh, '<:utf8', $file or die $!;
my $content = do { local $/; <$fh> };
close $fh;

my %groups = (
    "Тачки та колеса" => [3980, 4002, 4004, 4065, 4067],
    "Стрем'янки"      => [4033, 4035, 4037, 4039],
    "Тазики"          => [4049, 4051, 4053, 4055, 4057, 4059, 4061, 4063],
);

my %id_to_group;
for my $g (keys %groups) {
    for my $id (@{$groups{$g}}) {
        $id_to_group{$id} = $g;
    }
}

my $count = 0;
$content =~ s/(\{id:(\d+),[^}]+?subcat:"Тачки, стрем'янки та тазики",)(meta:)/
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
