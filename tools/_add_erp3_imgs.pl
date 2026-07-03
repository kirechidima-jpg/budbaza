use strict; use warnings;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

my %imgs = (
  # HPX masking film with PE film
  1590 => 'https://plenka.market/assets/cache/images/item/4180/2636c801c24da64a1d76bd9a7baf3b88.png',
  1596 => 'https://cdn.27.ua/original/82/7b/1737339_1.jpeg',
  # Schneider Resi9 RCBO 1P+N
  4582 => 'https://schneider.kiev.ua/image/cache/catalog/product/schneider_electric/schneider_electric_R9D25616-600x600.jpg',
  4584 => 'https://schneider.kiev.ua/image/cache/catalog/product/schneider_electric/schneider_electric_R9D25625-600x600.jpg',
  4586 => 'https://schneider.kiev.ua/image/cache/catalog/product/schneider_electric/schneider_electric_R9D25640-600x600.jpg',
  # Neomax junction/installation boxes
  4608 => 'https://stroysklad.com.ua/images/stories/virtuemart/product/NX1045.jpg',
  5026 => 'https://kapro.ua/imgs/m11235.jpg',
  # Luxel motion sensor
  4673 => 'https://luxel.ua/image/cache/catalog/Foto/Foto_ot_Dimi/Led_produkcija/Datchiki/Datcnik_on_Viki/MS02W-565x565.webp',
  # Feron/Ardero ML389-2 wall lamps
  4890 => 'https://feron.ua/image/cache/catalog/80253/80253_ml389-2_photo1_1000x1000-min-750x750.jpg',
  4892 => 'https://feron.ua/image/cache/catalog/80254/80254_ml389-2_photo1_1000x1000-min-750x750.jpg',
);

open(my $in, '<:encoding(UTF-8)', 'js/data.js') or die $!;
my @lines = <$in>;
close $in;

my ($added, $skipped) = (0, 0);
for my $ln (sort { $a <=> $b } keys %imgs) {
  my $idx = $ln - 1;
  my $url = $imgs{$ln};
  if ($lines[$idx] =~ s/,subcat:/,img:"$url",subcat:/) { $added++; }
  elsif ($lines[$idx] =~ /img:/) { print "SKIP line $ln (already has img)\n"; $skipped++; }
  else { print "WARN line $ln not matched\n"; }
}

open(my $out, '>:encoding(UTF-8)', 'js/data.js') or die $!;
print $out @lines;
close $out;
print "done: $added img added, $skipped skipped\n";
