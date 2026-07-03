#!/usr/bin/perl
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';

my $file = 'C:/Users/Pc/Desktop/budbaza/js/data.js';
open my $fh, '<:utf8', $file or die $!;
my $content = do { local $/; <$fh> };
close $fh;

my %groups = (
    'Граблі'            => [3880, 3882, 3884, 3886, 3888, 3890, 3975, 5597],
    'Лопати'            => [3931, 3933, 3935, 3937, 3939, 3941, 3943, 3945, 3947, 3949, 3951, 3953, 3955],
    'Секатори та ножиці'=> [3991, 3993, 3995, 4082, 4084, 4094, 4096, 4098, 4100, 4102, 4104, 4106, 4108, 4110, 4112],
    'Вила та кирки'     => [3824, 3826, 3828, 3974, 3976, 3978, 3997],
    'Мотижки та сапки'  => [3977, 3979, 4086, 4088, 4090],
);

my %id_to_group;
for my $group (keys %groups) {
    for my $id (@{$groups{$group}}) {
        $id_to_group{$id} = $group;
    }
}

my $count = 0;
$content =~ s/(\{id:(\d+),[^}]+?subcat:"Садовий інвентар",)(meta:)/$id_to_group{$2} ? do { $count++; "$1subsubcat:\"$id_to_group{$2}\",$3" } : "$1$3"/ge;

open my $out, '>:utf8', $file or die $!;
print $out $content;
close $out;

print "Done. Added subsubcat to $count products.\n";
