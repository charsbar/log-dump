package Log::Dump::Test::Capture::Basic;

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

sub log : Tests(4) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $capture->start;
    $target->log( debug => 'message' );
    $capture->stop;
    my $captured = join "\n", $capture->read;

    like $captured => qr/\[debug\] message/,
         $class->message('captured');
    unlike $captured => qr{Log.Dump(?!.Test)},
         $class->message('not from Log::Dump');
  }
}

sub dump : Tests(4) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $capture->start;
    $target->log( dump => ['message', 'array'] );
    $capture->stop;
    my $captured = join "\n", $capture->read;

    like $captured => qr/\[dump\] \["message", "array"\]/,
         $class->message('captured');
    unlike $captured => qr{Log.Dump(?!.Test)},
         $class->message('not from Log::Dump');
  }
}

sub error : Tests(4) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $capture->start;
    $target->log( error => 'message' );
    $capture->stop;
    my $captured = $capture->read;

    like $captured => qr/\[error\] message at/,
         $class->message('captured');
    unlike $captured => qr{Log.Dump(?!.Test)},
         $class->message('not from Log::Dump');
  }
}

sub fatal : Tests(4) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    eval { $target->log( fatal => 'message' ) };

    like $@ => qr/\[fatal\] message at/,
         $class->message('captured');
    unlike $@ => qr{Log.Dump(?!.Test)},
         $class->message('not from Log::Dump');
  }
}

sub array : Tests(4) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $capture->start;
    $target->log( array => 'message', 'array' );
    $capture->stop;
    my $captured = join "\n", $capture->read;

    like $captured => qr/\[array\] messagearray/,
         $class->message('captured');
    unlike $captured => qr{Log.Dump(?!.Test)},
         $class->message('not from Log::Dump');
  }
}

1;
