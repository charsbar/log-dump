package Log::Dump::Test::Child::Basic;

use strict;
use warnings;
use Log::Dump::Test::Capture::Basic 'base';

__PACKAGE__->mk_classdata( package => 'Log::Dump::Test::Child' );

1;
