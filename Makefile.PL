use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME          => 'Log::Dump',
  AUTHOR        => 'Kenichi Ishigaki <ishigaki@cpan.org>',
  VERSION_FROM  => 'lib/Log/Dump.pm',
  ABSTRACT_FROM => 'lib/Log/Dump.pm',
  PREREQ_PM => {
    'Data::Dump'          => 0,
    'IO::File'            => 0,
    'IO::Capture'         => 0,
    'Sub::Install'        => 0,
    'Test::Classy'        => '0.04',
    'Test::More'          => '0.47',
    'Test::UseAllModules' => '0.09',
  },
  ($ExtUtils::MakeMaker::VERSION >= 6.31
    ? ( LICENSE => 'perl' )
    : ()
  ),
);
