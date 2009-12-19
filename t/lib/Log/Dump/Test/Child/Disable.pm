package Log::Dump::Test::Child::Disable;

use strict;
use warnings;
use Log::Dump::Test::Capture::Disable 'base';

__PACKAGE__->mk_classdata( package => 'Log::Dump::Test::Child' );

1;
