package Log::Dump::Test::Capture::Disable;

use strict;
use warnings;
use Test::Classy::Base;

__PACKAGE__->mk_classdata( package => 'Log::Dump::Test::Class' );
__PACKAGE__->mk_classdata('capture');

sub initialize {
  my $class = shift;
  eval { require IO::Capture::Stderr };
  $class->skip_this_class('this test requires IO::Capture') if $@;

  my $package = $class->package;
  eval "require $package";
  $class->skip_this_class($@) if $@;

  $class->capture( IO::Capture::Stderr->new );
}

sub disable : Tests(4) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $target->logger(0);
    $capture->start;
    $target->log( array => 'message', 'array' );
    $capture->stop;

    ok !$capture->read, $class->message('log is disabled');

    $target->logger(1);
    $capture->start;
    $target->log( debug => 'debug' );
    $capture->stop;

    like $capture->read => qr/\[debug\] debug/,
         $class->message('captured');
  }
}

1;
