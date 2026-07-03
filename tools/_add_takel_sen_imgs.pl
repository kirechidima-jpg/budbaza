use strict; use warnings;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

my %imgs = (
  # Takel RE* tools
  2199 => 'https://takel.ua/image/cache/catalog/19kategoriya/19.7/re15060/re15060-1000x1000.jpg',
  2203 => 'https://takel.ua/image/cache/catalog/18kategoriya_new/18.9/re15080-1000x1000.jpg',
  2205 => 'https://takel.ua/image/cache/catalog/18kategoriya_new/18.9/re15082%281%29-1000x1000.jpg',
  2606 => 'https://takel.ua/image/cache/catalog/foto-kategorij/1280613-900x600.jpg',
  # Гільзи з'єднувальні
  4639 => 'https://takel.ua/image/cache/catalog/3kategoriya/zaglavfotometal3kat/3.6zaglav-900x600.jpg',
  4640 => 'https://takel.ua/image/cache/catalog/3kategoriya/zaglavfotometal3kat/3.6zaglav-900x600.jpg',
  4642 => 'https://takel.ua/image/cache/catalog/3kategoriya/zaglavfotometal3kat/3.6zaglav-900x600.jpg',
  # Feron SEN sensors
  4548 => 'https://feron.ua/image/cache/catalog/products/22009/lxp03-750x750.jpg',
  4669 => 'https://feron.ua/image/cache/catalog/products/22064/sen127_nov-750x750.jpg',
  4675 => 'https://feron.ua/image/cache/catalog/22055/sen25-750x750.jpg',
  4677 => 'https://feron.ua/image/cache/catalog/products/22008/lxp02-750x750.jpg',
  # Наконечники штирьові
  4827 => 'https://takel.ua/image/cache/catalog/1kategoriya/fototovarov1.16/re10530-re10543-1000x1000.jpg',
  4829 => 'https://takel.ua/image/cache/catalog/vedro/re10534-1000x1000.jpg',
  4839 => 'https://takel.ua/image/cache/catalog/4kategoriya_new/4.1/4.1.2/500008/500008-1000x1000.jpg',
  # Термоусадки з клеєм 3:1
  5172 => 'https://takel.ua/image/cache/catalog/new_photo_category/10_kategoriya/10.2/10.2.1/10_2_1_zaglav_photo-900x600.jpg',
  5178 => 'https://takel.ua/image/cache/catalog/new_photo_category/10_kategoriya/10.2/10.2.1/10_2_1_zaglav_photo-900x600.jpg',
  5180 => 'https://takel.ua/image/cache/catalog/new_photo_category/10_kategoriya/10.2/10.2.1/10_2_1_zaglav_photo-900x600.jpg',
  5182 => 'https://takel.ua/image/cache/catalog/new_photo_category/10_kategoriya/10.2/10.2.1/10_2_1_zaglav_photo-900x600.jpg',
  5184 => 'https://takel.ua/image/cache/catalog/new_photo_category/10_kategoriya/10.2/10.2.1/10_2_1_zaglav_photo-900x600.jpg',
  5186 => 'https://takel.ua/image/cache/catalog/new_photo_category/10_kategoriya/10.2/10.2.1/10_2_1_zaglav_photo-900x600.jpg',
  5188 => 'https://takel.ua/image/cache/catalog/new_photo_category/10_kategoriya/10.2/10.2.1/10_2_1_zaglav_photo-900x600.jpg',
  5190 => 'https://takel.ua/image/cache/catalog/new_photo_category/10_kategoriya/10.2/10.2.1/10_2_1_zaglav_photo-900x600.jpg',
  # Термоусадка без клею 2:1
  5206 => 'https://takel.ua/image/cache/catalog/13kategoriya/13.1.3/zaglavnoefoto13.1.3-900x600.jpg',
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
