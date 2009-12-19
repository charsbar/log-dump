package Log::Dump::Test::Basic::Has;

use strict;
use warnings;
use Test::Classy::Base;
use Log::Dump::Test::Class;

sub class_has : Tests(5) {
  my $class = shift;

  foreach my $method (qw( log logger logfilter logfile logcolor )) {
    ok(Log::Dump::Test::Class->can($method),
       $class->message($method));
  }
}

sub object_has : Tests(5) {
  my $class = shift;

  my $object = Log::Dump::Test::Class->new;

  foreach my $method (qw( log logger logfilter logfile logcolor )) {
    ok($object->can($method),
       $class->message($method));
  }
}

1;
