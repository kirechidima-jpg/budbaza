use strict;
use warnings;
open(my $f, '<:encoding(UTF-8)', 'js/data.js') or die $!;
my $n = 0;
my $errors = 0;
while(my $line = <$f>) {
    $n++;
    my $stripped = $line;
    $stripped =~ s/\\\"//g;
    my $q = ($stripped =~ tr/"//);
    if ($q % 2 != 0) {
        print "Line $n (odd quotes=$q): $line";
        $errors++;
        last if $errors > 10;
    }
}
close $f;
print "Total lines: $n, errors: $errors\n";
