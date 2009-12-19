use strict;
use warnings;
use lib 't/lib';
use Test::Classy;

load_tests_from 'Log::Dump::Test::Capture';
run_tests;
