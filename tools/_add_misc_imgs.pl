use strict; use warnings;

my %imgs = (
  # HPX 4800 Delikatne masking tapes
  1500 => 'https://hpx.ua/wp-content/uploads/2024/07/sr3825_cam03.webp',
  1502 => 'https://hpx.ua/wp-content/uploads/2024/07/sr3825_cam03.webp',
  # Ultra Mount double-sided tape (same image for all widths)
  1690 => 'https://hpx.ua/wp-content/uploads/2022/10/um1902_cam03_new-scaled.png',
  1692 => 'https://hpx.ua/wp-content/uploads/2022/10/um1902_cam03_new-scaled.png',
  1694 => 'https://hpx.ua/wp-content/uploads/2022/10/um1902_cam03_new-scaled.png',
  # Stanley STHT10424-0
  1711 => 'https://www.stanleyblackanddecker.com/EMEA/PRODUCT/IMAGES/HIRES/STHT10424-0_1.jpg',
  # Ardero SEN55 IP65
  3677 => 'https://feron.ua/image/cache/catalog/80350/80350_sen55_photo2-min-750x750.jpg',
  # Ardero SEN53
  4550 => 'https://feron.ua/image/cache/catalog/80346/80346_sen53_inter-min-750x750.jpg',
  # Ardero SEN52
  4667 => 'https://feron.ua/image/cache/catalog/80344/80344_sen52_inter-min-750x750.jpg',
  # Feron SEN5
  4671 => 'https://feron.ua/image/cache/catalog/22006/22006_sen5_photo-min-750x750.jpg',
  # Hager SFT switches
  4990 => 'https://hager-shop.com.ua/imgs/m2749.jpg',
  4992 => 'https://hager-shop.com.ua/imgs/m2753.jpg',
  4994 => 'https://hager-shop.com.ua/imgs/m2751.jpg',
  4996 => 'https://hager-shop.com.ua/imgs/m2752.jpg',
  # Videx IP65 triple socket
  5071 => 'https://videx.ua/files/products/3675ec82-3cd4-11ee-836b-78e7d1920008.1600x1340w.jpeg',
  # Hager VZ00UP
  5073 => 'https://hager-shop.com.ua/imgs/m14080.jpg',
  # Hager VZ461-464
  5127 => 'https://hager-shop.com.ua/imgs/m551.jpg',
  5129 => 'https://hager-shop.com.ua/imgs/m552.jpg',
  5131 => 'https://hager-shop.com.ua/imgs/m553.jpg',
  5133 => 'https://hager-shop.com.ua/imgs/m554.jpg',
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
