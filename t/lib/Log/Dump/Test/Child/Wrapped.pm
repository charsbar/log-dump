package Log::Dump::Test::Child::Wrapped;

use strict;
use warnings;
use Log::Dump::Test::Capture::Wrapped 'base';

__PACKAGE__->mk_classdata( package => 'Log::Dump::Test::Child' );

sub child : Tests(2) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $capture->start;
    $target->child;
    $capture->stop;

    like $capture->read => qr/\[child\] child/,
         $class->message('captured');
  }
}

1;
