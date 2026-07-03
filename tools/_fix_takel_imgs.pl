use strict; use warnings;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

my %imgs = (
  # TAKEL 1P lower amperages (takel.ua)
  4467 => 'https://takel.ua/image/cache/catalog/1kategoriya_new/1.1/1.1.1/506010/506010-1000x1000.jpg', # 1р.-10А TAKEL
  4471 => 'https://takel.ua/image/cache/catalog/1kategoriya_new/1.1/1.1.1/506012/506012-1000x1000.jpg', # 1р.-16А TAKEL
  4475 => 'https://takel.ua/image/cache/catalog/1kategoriya_new/1.1/1.1.1/506013/506013-1000x1000.jpg', # 1р.-20А TAKEL
  4479 => 'https://takel.ua/image/cache/catalog/1kategoriya_new/1.1/1.1.1/506014/506014-1000x1000.jpg', # 1р.-25А TAKEL
  4487 => 'https://takel.ua/image/cache/catalog/1_kategoriya_new/1.1.1/506017/506017-1000x1000.jpg',   # 1р.-50А TAKEL
  4491 => 'https://takel.ua/image/cache/catalog/1_kategoriya_new/1.1.1/506018/506018-1000x1000.jpg',   # 1р.-63А TAKEL
  # TAKEL 2P (takel.ua)
  4529 => 'https://takel.ua/image/cache/catalog/1_kategoriya_new/1.1.1/506029/506029-1000x1000.jpg',   # 2р.-10А TAKEL
  4531 => 'https://takel.ua/image/cache/catalog/1kategoriya_new/1.1/1.1.1/506031/506031-1000x1000.jpg', # 2р.-16А TAKEL
  4533 => 'https://takel.ua/image/cache/catalog/1kategoriya_new/1.1/1.1.1/506033/506033-1000x1000.jpg', # 2р.-25А TAKEL
  # ИЭК MCBs (rozetka.com.ua)
  4427 => 'https://content.rozetka.com.ua/goods/images/big/423571249.png',  # 1р 32А ИЭК
  4429 => 'https://content1.rozetka.com.ua/goods/images/big/483441944.jpg', # 1р 32А Viko
  4431 => 'https://content1.rozetka.com.ua/goods/images/big/559255038.jpg', # 1р 40А ИЭК
  4495 => 'https://content1.rozetka.com.ua/goods/images/big/423570218.png', # 2р 32А ИЭК
  4497 => 'https://content2.rozetka.com.ua/goods/images/big/324077865.png', # 2р 40А ИЭК
  4537 => 'https://content2.rozetka.com.ua/goods/images/big/324079432.png', # 3р 40А ИЭК
  4539 => 'https://content1.rozetka.com.ua/goods/images/big/591659836.png', # 3р 63А ИЭК
  5113 => 'https://content2.rozetka.com.ua/goods/images/big/332444410.png', # УЗО 2р 50А ИЭК
);

open(my $in, '<:encoding(UTF-8)', 'js/data.js') or die $!;
my @lines = <$in>;
close $in;

my $ok = 0;
for my $ln (sort { $a <=> $b } keys %imgs) {
  my $idx = $ln - 1;
  my $url = $imgs{$ln};
  if ($lines[$idx] =~ s/img:"[^"]*"/img:"$url"/) { $ok++; }
  else { print "WARN line $ln not matched\n"; }
}

open(my $out, '>:encoding(UTF-8)', 'js/data.js') or die $!;
print $out @lines;
close $out;
print "done: $ok imgs replaced\n";
