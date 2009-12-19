package Log::Dump::Test::Capture::File;

use strict;
use warnings;
use Test::Classy::Base;

__PACKAGE__->mk_classdata( package => 'Log::Dump::Test::Class' );
__PACKAGE__->mk_classdata('capture');

sub initialize {
  my $class = shift;
  eval { require IO::Capture::Stderr };
  $class->skip_this_class('this test requires IO::Capture') if $@;
  eval { require File::Temp };
  $class->skip_this_class('this test requires File::Temp') if $@;

  my $package = $class->package;
  eval "require $package";
  $class->skip_this_class($@) if $@;

  $class->capture( IO::Capture::Stderr->new );
}

sub file : Tests(14) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  my $logfile = File::Temp::tmpnam();

  foreach my $target ( $package, $object ) {
    unlink $logfile if -f $logfile;

    ok !-f $logfile, $class->message('logfile does not exist');
    $target->logfile($logfile);
    $capture->start;
    $target->log( debug => 'message' );
    $capture->stop;

    like $capture->read => qr/\[debug\] message/,
         $class->message('captured');

    $target->logfile(''); # this should close the file

    ok -f $logfile, $class->message('logfile does exist');
    open my $fh, '<', $logfile;
    my $read = <$fh>;
    like $read => qr/\[debug\] message/,
         $class->message('captured from logfile');
    close $fh;

    unlink $logfile;
    ok !-f $logfile, $class->message('logfile is removed');

    $capture->start;
    $target->log( debug => 'message' );
    $capture->stop;

    like $capture->read => qr/\[debug\] message/,
         $class->message('captured');

    ok !-f $logfile, $class->message('logfile does not exist');
  }
}

1;
