use strict; use warnings;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

open(my $in, '<:encoding(UTF-8)', 'js/data.js') or die $!;
my @lines = <$in>;
close $in;

my $changed = 0;
for my $line (@lines) {
  next unless $line =~ /subcat:"Автомати та УЗО"/;

  # extract name
  my ($name) = $line =~ /name:"([^"]*)"/;

  # detect brand
  my $brand;
  if    ($name =~ /Hager/)             { $brand = "Хагер"; }
  elsif ($name =~ /Shneider|Schneider/){ $brand = "Шнайдер"; }
  else                                  { $brand = "Такел"; }

  # detect type (order matters!)
  my $type;
  if    ($name =~ /УЗО|Диф/)            { $type = "УЗО + Диф"; }
  elsif ($name =~ /Переключ|АВР|Контактор/){ $type = "Переключатель"; }
  elsif ($name =~ /1р/)                  { $type = "1п"; }
  elsif ($name =~ /2р/)                  { $type = "2п"; }
  elsif ($name =~ /3р|4р/)              { $type = "3п"; }
  else                                   { $type = "Переключатель"; }

  # insert subsubcat + subsubsubcat right after subcat:"Автомати та УЗО"
  if ($line =~ s/(subcat:"Автомати та УЗО")/$1,subsubcat:"$brand",subsubsubcat:"$type"/) {
    $changed++;
  } else {
    print "WARN not matched: $name\n";
  }
}

open(my $out, '>:encoding(UTF-8)', 'js/data.js') or die $!;
print $out @lines;
close $out;
print "done: $changed items updated\n";
