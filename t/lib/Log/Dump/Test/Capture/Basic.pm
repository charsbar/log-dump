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

sub log : Tests(2) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $capture->start;
    $target->log( debug => 'message' );
    $capture->stop;

    like $capture->read => qr/\[debug\] message/,
         $class->message('captured');
  }
}

sub dump : Tests(2) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $capture->start;
    $target->log( dump => ['message', 'array'] );
    $capture->stop;

    my $read = join "\n", $capture->read;

    like $read => qr/\[dump\] \["message", "array"\]/,
         $class->message('captured');
  }
}

sub error : Tests(2) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $capture->start;
    $target->log( error => 'message' );
    $capture->stop;

    like $capture->read => qr/\[error\] message at/,
         $class->message('captured');
  }
}

sub fatal : Tests(2) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    eval { $target->log( fatal => 'message' ) };

    like $@ => qr/\[fatal\] message at/,
         $class->message('captured');
  }
}

sub array : Tests(2) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $capture->start;
    $target->log( array => 'message', 'array' );
    $capture->stop;

    my $read = join "\n", $capture->read;

    like $read => qr/\[array\] messagearray/,
         $class->message('captured');
  }
}

1;
