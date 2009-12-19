package Log::Dump::Test::Child::Filter;

use strict;
use warnings;
use Log::Dump::Test::Capture::Filter 'base';

__PACKAGE__->mk_classdata( package => 'Log::Dump::Test::Child' );

1;
