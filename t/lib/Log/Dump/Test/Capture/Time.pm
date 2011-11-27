package Log::Dump::Test::Capture::Time;

use strict;
use warnings;
use Test::Classy::Base;

__PACKAGE__->mk_classdata( package => 'Log::Dump::Test::Class' );
__PACKAGE__->mk_classdata('capture');

sub initialize {
  my $class = shift;
  eval { require Time::Piece };
  $class->skip_this_class('this test requires Time::Piece') if $@;
  eval { require IO::Capture::Stderr };
  $class->skip_this_class('this test requires IO::Capture') if $@;

  my $package = $class->package;
  eval "require $package";
  $class->skip_this_class($@) if $@;

  $class->capture( IO::Capture::Stderr->new );
}

sub time : Tests(8) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $target->logtime(1);
    $capture->start;
    $target->log( time => 'message' );
    $capture->stop;

    my $with_time = $capture->read;
    like $with_time => qr/^\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2} \[time\] message/,
         $class->message('captured');
    $target->logtime(0); # no more time

    $capture->start;
    $target->log( time => 'message' );
    $capture->stop;

    my $without_time = $capture->read;
    like $without_time => qr/^\[time\] message/,
         $class->message('captured');

    ok $with_time ne $without_time, $class->message('both are different');

    # custom format
    $target->logtime('%Y-%m-%d');
    $capture->start;
    $target->log( time => 'message' );
    $capture->stop;

    $with_time = $capture->read;
    like $with_time => qr/^\d{4}\-\d{2}\-\d{2} \[time\] message/,
         $class->message('captured');
    $target->logtime(0); # no more time
  }
}

1;
