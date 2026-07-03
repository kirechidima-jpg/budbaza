#!/usr/bin/perl
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';

my $file = 'C:/Users/Pc/Desktop/budbaza/js/data.js';
open my $fh, '<:utf8', $file or die $!;
my $content = do { local $/; <$fh> };
close $fh;

my %groups = (
    "5 см"  => [3907],
    "10 см" => [3877,3879,3881,3883,3885,3887,3889],
    "15 см" => [3891,3893,3895,3897,3899,5561],
    "20 см" => [3901,3903,3905],
);

my %id_to_group;
for my $g (keys %groups) {
    for my $id (@{$groups{$g}}) {
        $id_to_group{$id} = $g;
    }
}

my $count = 0;
$content =~ s/(\{id:(\d+),[^}]+?subsubcat:"Лента битумна",)(meta:)/
    do {
        my $id = $2;
        if ($id_to_group{$id}) {
            $count++;
            "$1subsubsubcat:\"$id_to_group{$id}\",$3"
        } else {
            "$1$3"
        }
    }
/ge;

open my $out, '>:utf8', $file or die $!;
print $out $content;
close $out;

print "Done. Added subsubsubcat to $count products.\n";
