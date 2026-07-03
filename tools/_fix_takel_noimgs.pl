use strict; use warnings;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

# Products that have NO img field — insert before subcat:
my %add_img = (
  4421 => 'https://content2.rozetka.com.ua/goods/images/big/612076222.png',  # АВР 2р 63А
  4423 => 'https://content.rozetka.com.ua/goods/images/big/379580386.jpg',   # АВР 4р 125А
  4425 => 'https://content2.rozetka.com.ua/goods/images/big/652993934.png',  # АВР 4р 63А
  4761 => 'https://content.rozetka.com.ua/goods/images/big/472301653.jpg',   # Контактор MC4 6мм
  5006 => 'https://content2.rozetka.com.ua/goods/images/big/354961076.jpg',  # Переключ. 3р-25А ИЭК
  5008 => 'https://content2.rozetka.com.ua/goods/images/big/362115079.jpg',  # Переключ. 3р-40А CNC
);

open(my $in, '<:encoding(UTF-8)', 'js/data.js') or die $!;
my @lines = <$in>;
close $in;

my ($added, $skipped) = (0, 0);
for my $ln (sort { $a <=> $b } keys %add_img) {
  my $idx = $ln - 1;
  my $url = $add_img{$ln};
  if ($lines[$idx] =~ /img:/) {
    print "SKIP line $ln (already has img)\n"; $skipped++;
  } elsif ($lines[$idx] =~ s/,subcat:/,img:"$url",subcat:/) {
    $added++;
  } else {
    print "WARN line $ln not matched\n";
  }
}

open(my $out, '>:encoding(UTF-8)', 'js/data.js') or die $!;
print $out @lines;
close $out;
print "done: $added added, $skipped skipped\n";
