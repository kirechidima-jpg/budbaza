use strict; use warnings;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

# Schneider Resi9 MCB image URL pattern:
# https://schneider.kiev.ua/image/cache/catalog/product/schneider_electric/schneider_electric_R9F12PCC-600x600.jpg
# where P=poles digit, CC=current (06,10,16,20,25,32,40,50,63)
sub resi9_url {
  my ($poles, $amps) = @_;
  my $cc = sprintf("%02d", $amps);
  return "https://schneider.kiev.ua/image/cache/catalog/product/schneider_electric/schneider_electric_R9F12${poles}${cc}-600x600.jpg";
}

my %imgs = (
  # 1P
  4493 => resi9_url(1,  6),   # 6А
  4465 => resi9_url(1, 10),   # 10А
  4469 => resi9_url(1, 16),   # 16А
  4473 => resi9_url(1, 20),   # 20А
  4477 => resi9_url(1, 25),   # 25А
  4481 => resi9_url(1, 32),   # 32А
  4483 => resi9_url(1, 40),   # 40А
  4485 => resi9_url(1, 50),   # 50А
  4489 => resi9_url(1, 63),   # 63А
  # 2P
  4517 => resi9_url(2, 25),   # 25А
  4519 => resi9_url(2, 32),   # 32А
  4525 => resi9_url(2, 40),   # 40А
  4499 => resi9_url(2, 50),   # 50А
  4527 => resi9_url(2, 63),   # 63А
  # 3P
  4426 => resi9_url(3, 25),   # 25А
  4428 => resi9_url(3, 32),   # 32А
  # 4432 = 3P 40A already has correct image (R9F12340), skip
  4436 => resi9_url(3, 50),   # 50А
  4440 => resi9_url(3, 63),   # 63А
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
