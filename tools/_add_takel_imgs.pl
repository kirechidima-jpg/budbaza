use strict; use warnings;

my %imgs = (
  # DIN rails
  4554 => 'https://takel.ua/image/cache/catalog/5kategoriya/501017-1000x1000.jpg',
  4556 => 'https://takel.ua/image/cache/catalog/5kategoriya/501018-1000x1000.jpg',
  4558 => 'https://takel.ua/image/cache/catalog/5kategoriya/501019-1000x1000.jpg',
  4560 => 'https://takel.ua/image/cache/catalog/5kategoriya/5.1/5.1.1/501001-1000x1000.jpg',
  4562 => 'https://takel.ua/image/cache/catalog/5kategoriya/5.1/5.1.4/501013-1000x1000.jpg',
  4564 => 'https://takel.ua/image/cache/catalog/5kategoriya/501014-1000x1000.jpg',
  4566 => 'https://takel.ua/image/cache/catalog/5kategoriya/501015-1000x1000.jpg',
  4568 => 'https://takel.ua/image/cache/catalog/5kategoriya/501016-1000x1000.jpg',
  # WGn terminals
  4751 => 'https://takel.ua/image/cache/catalog/7kategoriya/7.9/7.9.2/501075-1000x1000.jpg',
  4758 => 'https://takel.ua/image/cache/catalog/7kategoriya/7.9/7.9.2/501076-1000x1000.jpg',
  4766 => 'https://takel.ua/image/cache/catalog/7kategoriya/7.9/7.9.2/501078-1000x1000.jpg',
  # ring lug SC 3.5-5
  4843 => 'https://takel.ua/image/cache/catalog/2kategoriya/2.10/500350-500383-1000x1000.jpg',
  # NT tube lugs
  4891 => 'https://takel.ua/image/cache/catalog/2kategoriya/2.1/500680-1000x1000.jpg',
  4893 => 'https://takel.ua/image/cache/catalog/2kategoriya/2.1/500679ser-1000x1000.jpg',
  4911 => 'https://takel.ua/image/cache/catalog/2kategoriya/2.1/500684m-1000x1000.jpg',
  # TE tube lugs
  4913 => 'https://takel.ua/image/cache/catalog/2kategoriya/2.3/500713-1000x1000.jpg',
  4917 => 'https://takel.ua/image/cache/catalog/2kategoriya/2.3/500720-1000x1000.jpg',
  # GTY sleeves
  4619 => 'https://takel.ua/image/cache/catalog/3kategoriya/3.1-1000x1000.jpg',
  4623 => 'https://takel.ua/image/cache/catalog/3kategoriya/3.1-1000x1000.jpg',
  4625 => 'https://takel.ua/image/cache/catalog/3kategoriya/3.1-1000x1000.jpg',
  4627 => 'https://takel.ua/image/cache/catalog/3kategoriya/3.1-1000x1000.jpg',
  4631 => 'https://takel.ua/image/cache/catalog/3kategoriya/3.1-1000x1000.jpg',
  # DL-95 aluminum lug
  4942 => 'https://takel.ua/image/cache/catalog/1kategoriya/fototovarov1.13kat/500250-500263-1000x1000.jpg',
  # bus bars
  5216 => 'https://takel.ua/image/cache/catalog/6kategoriya/6.1/501020%3B501036-1000x1000.jpg',
  5220 => 'https://takel.ua/image/cache/catalog/6kategoriya/6.1/501022501026501037-1000x1000.jpg',
);

open(my $in, '<:encoding(UTF-8)', 'js/data.js') or die $!;
my @lines = <$in>;
close $in;

my $ok = 0;
for my $ln (sort { $a <=> $b } keys %imgs) {
  my $idx = $ln - 1;
  my $url = $imgs{$ln};
  if ($lines[$idx] =~ s/,subcat:/,img:"$url",subcat:/) {
    $ok++;
  } elsif ($lines[$idx] =~ /img:/) {
    print "SKIP line $ln (already has img)\n";
  } else {
    print "WARN line $ln not matched\n";
  }
}

open(my $out, '>:encoding(UTF-8)', 'js/data.js') or die $!;
print $out @lines;
close $out;
print "done, applied $ok of " . scalar(keys %imgs) . "\n";
