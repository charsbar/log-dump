package Log::Dump::Test::Capture::Colored;

use strict;
use warnings;
use Test::Classy::Base;

__PACKAGE__->mk_classdata( package => 'Log::Dump::Test::Class' );
__PACKAGE__->mk_classdata('capture');

sub initialize {
  my $class = shift;
  eval { require Term::ANSIColor };
  $class->skip_this_class('this test requires Term::ANSIColor') if $@;
  eval { require IO::Capture::Stderr };
  $class->skip_this_class('this test requires IO::Capture') if $@;

  my $package = $class->package;
  eval "require $package";
  $class->skip_this_class($@) if $@;

  $class->capture( IO::Capture::Stderr->new );
}

sub color : Tests(6) {
  my $class = shift;

  my $capture = $class->capture;
  my $package = $class->package;
  my $object  = $package->new;

  foreach my $target ( $package, $object ) {
    $target->logcolor( color => 'bold red on_white' );
    $capture->start;
    $target->log( color => 'message' );
    $capture->stop;

    # Let's see a colored message to see if it actually works
    $target->log( color => 'message' );

    my $colored = $capture->read;
    like $colored => qr/\[color\] .+message.+/,
         $class->message('captured');
    $target->logcolor(''); # no more color

    $capture->start;
    $target->log( color => 'message' );
    $capture->stop;

    my $uncolored = $capture->read;
    like $uncolored => qr/\[color\] message/,
         $class->message('captured');

    ok $colored ne $uncolored, $class->message('colored and uncolored are different');
  }
}

1;
