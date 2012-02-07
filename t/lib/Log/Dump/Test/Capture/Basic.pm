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

sub logger : Tests(14) {
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

    $target->logger(0);
    is $target->logger => 0, $class->message('logger value is correct');

    $capture->start;
    $target->log( debug => 'logger is disabled' );
    $capture->stop;
    $captured = join "\n", $capture->read;

    ok !$captured, $class->message('logger is disabled');

    $target->logger(1);
    is $target->logger => 1, $class->message('logger value is correct');

    $capture->start;
    $target->log( debug => 'logger is enabled' );
    $capture->stop;
    $captured = join "\n", $capture->read;

    like $captured => qr/\[debug\] logger is enabled/,
         $class->message('captured');
    unlike $captured => qr{Log.Dump(?!.Test)},
         $class->message('not from Log::Dump');
  }
}

sub custom_logger : Tests(18) {
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

    $target->logger(0);
    is $target->logger => 0, $class->message('logger value is correct');

    $capture->start;
    $target->log( debug => 'logger is disabled' );
    $capture->stop;
    $captured = join "\n", $capture->read;

    ok !$captured, $class->message('logger is disabled');

    $target->logger('Log::Dump::Test::CustomLogger');
    is $target->logger => 'Log::Dump::Test::CustomLogger', $class->message('logger value is correct');

    $capture->start;
    $target->log( debug => 'custom logger is enabled' );
    $capture->stop;
    $captured = join "\n", $capture->read;

    like $captured => qr/debug custom logger is enabled/,
         $class->message('captured');
    unlike $captured => qr{Log.Dump(?!.Test)},
         $class->message('not from Log::Dump');

    my $logger_object = Log::Dump::Test::CustomLogger->new;
    $target->logger($logger_object);

    $capture->start;
    $target->log( debug => 'custom logger object is enabled' );
    $capture->stop;
    $captured = join "\n", $capture->read;

    like $captured => qr/debug custom logger object is enabled/,
         $class->message('captured');
    unlike $captured => qr{Log.Dump(?!.Test)},
         $class->message('not from Log::Dump');

    $target->logger(1);  # back to the default
  }
}

package #
  Log::Dump::Test::CustomLogger;

sub new { bless {}, shift }
sub log { shift; print STDERR join ' ', @_ }

1;
