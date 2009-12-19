package Log::Dump::Test::Class::Basic;

use strict;
use warnings;
use Test::Classy::Base;
use Log::Dump::Test::ClassUserA;
use Log::Dump::Test::ClassUserB;

sub log_class_has : Tests(5) {
  my $class = shift;

  foreach my $method (qw( log logger logfilter logfile logcolor )) {
    ok(Log::Dump::Test::ClassLog->can($method),
       $class->message($method));
  }
}

sub log_object_has : Tests(5) {
  my $class = shift;

  my $object = Log::Dump::Test::ClassLog->new;

  foreach my $method (qw( log logger logfilter logfile logcolor )) {
    ok($object->can($method),
       $class->message($method));
  }
}

sub user_class_has : Tests(5) {
  my $class = shift;

  foreach my $method (qw( log logger logfilter logfile logcolor )) {
    ok(Log::Dump::Test::ClassUserA->can($method),
       $class->message($method));
  }
}

sub user_object_has : Tests(5) {
  my $class = shift;

  my $object = Log::Dump::Test::ClassUserA->new;

  foreach my $method (qw( log logger logfilter logfile logcolor )) {
    ok($object->can($method),
       $class->message($method));
  }
}

sub class_logger : Tests(6) {
  my $class = shift;

  ok(!defined Log::Dump::Test::ClassUserA->logger,
     $class->message('logger for user A is not defined'));

  ok(!defined Log::Dump::Test::ClassUserB->logger,
     $class->message('logger for user A is not defined'));

  ok(!defined Log::Dump::Class->logger,
     $class->message('base logger is not defined'));

  Log::Dump::Test::ClassUserA->logger(0);

  ok(defined Log::Dump::Test::ClassUserB->logger,
     $class->message('logger for user B is also defined'));

  ok(defined Log::Dump::Test::ClassLog->logger,
     $class->message('class logger is also defined'));

  ok(!defined Log::Dump::Class->logger,
     $class->message('still, base logger is not defined'));
}

sub object_logger : Tests(7) {
  my $class = shift;

  Log::Dump::Test::ClassUserA->logger(undef);
  Log::Dump::Test::ClassUserB->logger(undef);

  my $user_a = Log::Dump::Test::ClassUserA->new;
  my $user_b = Log::Dump::Test::ClassUserB->new;

  ok(!defined $user_a->logger,
     $class->message('logger for user A is not defined'));

  ok(!defined $user_b->logger,
     $class->message('logger for user A is not defined'));

  ok(!defined Log::Dump::Test::ClassLog->logger,
     $class->message('class logger is not defined'));

  ok(!defined Log::Dump::Class->logger,
     $class->message('base logger is not defined'));

  $user_a->logger(0);

  ok(defined $user_b->logger,
     $class->message('logger for user B is also defined'));

  ok(defined Log::Dump::Test::ClassLog->logger,
     $class->message('class logger is also defined'));

  ok(!defined Log::Dump::Class->logger,
     $class->message('still, base logger is not defined'));
}

1;
