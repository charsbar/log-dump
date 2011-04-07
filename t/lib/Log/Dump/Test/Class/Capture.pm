package Log::Dump::Test::Class::Capture;

use strict;
use warnings;
use Test::Classy::Base;
use Log::Dump::Test::ClassUserA;

__PACKAGE__->mk_classdata('capture');

sub initialize {
  my $class = shift;
  eval { require IO::Capture::Stderr };
  $class->skip_this_class('this test requires IO::Capture') if $@;

  Log::Dump::Test::ClassUserA->logger(1);

  $class->capture( IO::Capture::Stderr->new );
}

sub plain_usage : Tests(2) {
  my $class = shift;

  my $capture = $class->capture;

  $capture->start;
  Log::Dump::Test::ClassUserA->log( debug => 'message' );
  $capture->stop;
  my $captured = join "\n", $capture->read;

  like $captured => qr/\[debug\] message/,
    $class->message('captured');
  unlike $captured => qr{Log.Dump.Class},
    $class->message('not from Log::Dump::Class');
}

sub error : Tests(2) {
  my $class = shift;

  my $capture = $class->capture;

  $capture->start;
  Log::Dump::Test::ClassUserA->log( error => 'message' );
  $capture->stop;
  my $captured = join "\n", $capture->read;

  like $captured => qr/\[error\] message/,
    $class->message('captured');
  unlike $captured => qr{Log.Dump.Class},
    $class->message('not from Log::Dump::Class');
}

sub fatal : Tests(2) {
  my $class = shift;

  eval { Log::Dump::Test::ClassUserA->log( fatal => 'message' ) };

  like $@ => qr/\[fatal\] message/,
    $class->message('captured');
  unlike $@ => qr{Log.Dump.Class},
    $class->message('not from Log::Dump::Class');
}

1;
