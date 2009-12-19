package Log::Dump::Test::Loaded::Basic;

use strict;
use warnings;
use Test::Classy::Base;
use Log::Dump::Test::Loaded;

sub class_has : Tests(5) {
  my $class = shift;

  foreach my $method (qw( log logger logfilter logfile logcolor )) {
    ok(Log::Dump::Test::Loaded->can($method),
       $class->message($method));
  }
}

sub object_has : Tests(5) {
  my $class = shift;

  my $object = Log::Dump::Test::Loaded->new;

  foreach my $method (qw( log logger logfilter logfile logcolor )) {
    ok($object->can($method),
       $class->message($method));
  }
}

sub other_class_has : Tests(5) {
  my $class = shift;

  foreach my $method (qw( log logger logfilter logfile logcolor )) {
    ok(Log::Dump::Test::Loaded->test_class->can($method),
       $class->message($method));
  }
}

sub other_object_has : Tests(5) {
  my $class = shift;

  foreach my $method (qw( log logger logfilter logfile logcolor )) {
    ok(Log::Dump::Test::Loaded->test_object->can($method),
       $class->message($method));
  }
}

1;
