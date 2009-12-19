package Log::Dump::Test::Functions::Basic;

use strict;
use warnings;
use Test::Classy::Base;
use Log::Dump::Functions;

__PACKAGE__->mk_classdata('capture');

sub initialize {
  my $class = shift;
  eval { require IO::Capture::Stderr };
  $class->skip_this_class('this test requires IO::Capture') if $@;

  $class->capture( IO::Capture::Stderr->new );
}

sub plain_usage : Test {
  my $class = shift;

  my $capture = $class->capture;

  $capture->start;
  log( debug => 'message' );
  $capture->stop;

  like $capture->read => qr/\[debug\] message/,
    $class->message('captured');
}

1;
