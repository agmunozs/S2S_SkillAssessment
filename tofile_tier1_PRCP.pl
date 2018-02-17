#!/usr/bin/perl
for my $iter (10 .. 35) {
  system("rm -Rf output$iter");
  open my $out, '>>', "output$iter" or die "Can't write new file: $!";
  my @FILES = glob("PRCP*_1TIER_*train$iter*");
  foreach my $filename (@FILES){

     open(FILE, $filename) or die "Could not read from $filename, program halting.";
     while(<FILE>)
     {
      chomp;
      next unless $. == 3;
      @fields = split(' 0', $_);
      print $out "$fields[1]\n";
     }
   close FILE;
  }
}
for my $iter (11 .. 35) {
$iterp=$iter-1;
system("pr -mts' ' output$iterp output$iter > outputm");
system("mv outputm output$iter; rm -Rf output output$iterp");
}
system("mv output35 skillfile_1tier_prcp.txt");
exit;
