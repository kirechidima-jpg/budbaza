use strict; use warnings;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

# Lines that already HAVE img: — update the URL
my %update_img = (
  4432 => 'https://schneider.kiev.ua/image/cache/catalog/product/schneider_electric/schneider_electric_R9F12340-600x600.jpg',
  5117 => 'https://schneider.kiev.ua/image/cache/catalog/product/schneider_electric/schneider_electric_R9R51225-600x600.jpg',
  5123 => 'https://schneider.kiev.ua/image/cache/catalog/product/schneider_electric/schneider_electric_R9R51263-600x600.jpg',
  5125 => 'https://schneider.kiev.ua/image/cache/catalog/product/schneider_electric/schneider_electric_R9R51463-600x600.jpg',
);

# Lines that have NO img: — insert before subcat:
my %add_img = (
  4526 => 'https://schneider.net.ua/12571-large_default/vimikach-2-kl-se-sedna-design-sdd111105-bilij.jpg',
);

# Descriptions
my %descs = (
  4432 => 'Автоматичний вимикач Schneider Electric Resi9 R9F12340, 3P, 40А, крива C, 6кА. Для захисту трифазних кіл від струмів короткого замикання та перевантаження. Монтаж на DIN-рейку, займає 3 модулі.',
  4526 => 'Вимикач 2-клавішний Schneider Electric Sedna Design SDD111105, білий. Дозволяє незалежно керувати двома групами освітлення. Струм 10А/250В, матеріал ABS-UV, глянсова поверхня. Для прихованої проводки.',
  5117 => 'Диференційний вимикач навантаження Schneider Electric Resi9 R9R51225, 2P, 25А, 30мА, тип АС. Захист від ураження електричним струмом та пожежі. Монтаж на DIN-рейку, займає 2 модулі.',
  5123 => 'Диференційний вимикач навантаження Schneider Electric Resi9 R9R51263, 2P, 63А, 30мА, тип АС. Захист від ураження електричним струмом та пожежі. Монтаж на DIN-рейку, займає 2 модулі.',
  5125 => 'Диференційний вимикач навантаження Schneider Electric Resi9 R9R51463, 4P, 63А, 30мА, тип АС. Захист трифазних мереж від витоку струму та пожежі. Монтаж на DIN-рейку, займає 4 модулі.',
);

open(my $in, '<:encoding(UTF-8)', 'js/data.js') or die $!;
my @lines = <$in>;
close $in;

my ($img_upd, $img_add, $desc_ok) = (0, 0, 0);

for my $ln (keys %update_img) {
  my $idx = $ln - 1;
  my $url = $update_img{$ln};
  if ($lines[$idx] =~ s/img:"[^"]*"/img:"$url"/) { $img_upd++; }
  else { print "WARN update_img line $ln not matched\n"; }
}

for my $ln (keys %add_img) {
  my $idx = $ln - 1;
  my $url = $add_img{$ln};
  if ($lines[$idx] =~ s/,subcat:/,img:"$url",subcat:/) { $img_add++; }
  elsif ($lines[$idx] =~ /img:/) { print "SKIP add_img line $ln (already has img)\n"; }
  else { print "WARN add_img line $ln not matched\n"; }
}

for my $ln (keys %descs) {
  my $idx = $ln - 1;
  my $text = $descs{$ln};
  if ($lines[$idx] =~ s/desc:".*?",stock:/desc:"$text",stock:/) { $desc_ok++; }
  else { print "WARN desc line $ln not matched\n"; }
}

open(my $out, '>:encoding(UTF-8)', 'js/data.js') or die $!;
print $out @lines;
close $out;
print "done: $img_upd img updated, $img_add img added, $desc_ok desc written\n";
