package Log::Dump::Test::Capture::Filter;

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

sub filter : Tests(8) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $target->logfilter(qw/debug info/);
    $capture->start;
    $target->log( array => 'message', 'array' );
    $capture->stop;

    ok !$capture->read, $class->message('filtered out');

    $capture->start;
    $target->log( debug => 'debug' );
    $target->log( info  => 'info' );
    $capture->stop;

    like $capture->read => qr/\[debug\] debug/,
         $class->message('captured');
    like $capture->read => qr/\[info\] info/,
         $class->message('captured');

    $target->logfilter('');
    $capture->start;
    $target->log( array => 'message', 'array' );
    $capture->stop;

    my $read = join "\n", $capture->read;

    like $read => qr/\[array\] messagearray/,
         $class->message('captured again');
  }
}

sub negative_filter : Tests(8) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $target->logfilter(qw/!debug !info/);
    $capture->start;
    $target->log( debug => 'debug' );
    $target->log( info  => 'info' );
    $capture->stop;

    is $capture->read => undef, $class->message('filtered out');

    $capture->start;
    $target->log( array => 'message', 'array' );
    $capture->stop;

    like $capture->read => qr/\[array\] messagearray/,
         $class->message('captured');

    $target->logfilter('');
    $capture->start;
    $target->log( debug => 'debug' );
    $target->log( info  => 'info' );
    $capture->stop;

    my $read = join "\n", $capture->read;

    like $read => qr/\[debug\] debug/,
         $class->message('captured again');
    like $read => qr/\[info\] info/,
         $class->message('captured again');
  }
}

sub mixed_filter : Tests(10) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $target->logfilter(qw/!debug !info warn error/);
    $capture->start;
    $target->log( debug => 'debug' );
    $target->log( info  => 'info' );
    $target->log( array => 'message', 'array' );
    $capture->stop;

    is $capture->read => undef, $class->message('filtered out');

    $capture->start;
    $target->log( warn  => 'warn' );
    $target->log( error => 'error' );
    $capture->stop;

    like $capture->read => qr/\[warn\] warn/,
         $class->message('captured');
    like $capture->read => qr/\[error\] error/,
         $class->message('captured');

    $target->logfilter('');
    $capture->start;
    $target->log( debug => 'debug' );
    $target->log( info  => 'info' );
    $capture->stop;

    my $read = join "\n", $capture->read;

    like $read => qr/\[debug\] debug/,
         $class->message('captured again');
    like $read => qr/\[info\] info/,
         $class->message('captured again');
  }
}

1;
