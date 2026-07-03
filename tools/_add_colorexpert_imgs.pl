use strict; use warnings;

my %imgs = (
  # Simple flat brushes - yellow (lacquer series)
  1388 => 'https://colorclub.ua/content/images/26/356x285l85nn0/color-expert-penzel-fleitsevyi-dlia-lakiv-na-rochynnyku-30-mm-19333587974436.jpg',
  1400 => 'https://colorclub.ua/content/images/27/356x285l85nn0/color-expert-penzel-fleitsevyi-dlia-lakiv-na-rochynnyku-40-mm-21501466646236.jpg',
  1412 => 'https://colorclub.ua/content/images/21/356x356l85nn0/color-expert-kist-fleycevaja-dlja-lakov-na-vodnoy-osnove-50mm-x-14-mm-zheltaja-plastikovaja-ruchka-83161667294982.jpg',
  1420 => 'https://colorclub.ua/content/images/29/356x285l85nn0/color-expert-penzel-fleitsevyi-dlia-lakiv-na-rochynnyku-70-mm-46869617307105.jpg',
  # Simple flat brushes - green (wood protection series)
  1390 => 'https://colorclub.ua/content/images/17/356x356l85nn0/32112219233036.jpg',
  1402 => 'https://colorclub.ua/content/images/18/356x356l85nn0/45738404485165.jpg',
  1414 => 'https://colorclub.ua/content/images/19/356x356l85nn0/89111542974204.jpg',
  1422 => 'https://colorclub.ua/content/images/20/356x356l85nn0/62453780318684.jpg',
  # Simple flat brushes - red (wall painting series)
  1392 => 'https://colorclub.ua/content/images/46/356x244l85nn0/color-expert-penzel-fleitsevyi-plastmasova-ruchka-30-mm-55914086394199.jpg',
  1404 => 'https://colorclub.ua/content/images/28/356x240l85nn0/color-expert-penzel-fleitsevyi-plastmasova-ruchka-40-mm-50155604901722.jpg',
  1416 => 'https://colorclub.ua/content/images/29/356x219l85nn0/color-expert-penzel-fleitsevyi-plastmasova-ruchka-50-mm-55118909494687.jpg',
  1424 => 'https://colorclub.ua/content/images/30/356x222l85nn0/color-expert-penzel-fleitsevyi-plastmasova-ruchka-70-mm-42416193618980.jpg',
  # UniStar Gold series - yellow handle
  1394 => 'https://colorclub.ua/content/images/22/356x113l85nn0/color-expert-kist-fleycevaja-unistar-30mm-x-14-mm-3k-ruchka-gold-63820312934847.jpg',
  1406 => 'https://colorclub.ua/content/images/23/356x115l85nn0/color-expert-kist-fleycevaja-unistar-40mm-x-15-mm-3k-ruchka-gold-12705116747710.jpg',
  1426 => 'https://colorclub.ua/content/images/25/356x356l85nn0/43186266474615.jpg',
  # Red premium series
  1396 => 'https://colorclub.ua/content/images/49/356x142l85nn0/color-expert-penzel-fleitsevyi-30-mm-98954105645664.jpg',
  1410 => 'https://colorclub.ua/content/images/50/356x142l85nn0/color-expert-penzel-fleitsevyi-40-mm-46307265319020.jpg',
  1428 => 'https://colorclub.ua/content/images/48/356x141l85nn0/color-expert-penzel-fleitsevyi-80-mm-30266159944167.jpg',
  # 3K handle green series
  1398 => 'https://colorclub.ua/content/images/14/356x356l85nn0/39228434609648.jpg',
  1408 => 'https://colorclub.ua/content/images/13/356x356l85nn0/13947143086803.jpg',
  1418 => 'https://colorclub.ua/content/images/15/356x356l85nn0/78626605169411.jpg',
  1430 => 'https://colorclub.ua/content/images/16/356x356l85nn0/85659412590749.jpg',
  # Radiator brush
  1432 => 'https://colorclub.ua/content/images/17/356x356l85nn0/84790029469892.jpg',
  # Maklovitsa
  1633 => 'https://colorclub.ua/content/images/33/356x174l85nn0/color-expert-maklovytsia-standartna-nabyvna-100-mm-67286616932595.jpg',
  1635 => 'https://colorclub.ua/content/images/33/356x174l85nn0/color-expert-maklovytsia-standartna-nabyvna-100-mm-67286616932595.jpg',
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
