
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "An interface to a Riak server.",
  "AUTHOR" => "Andrew Nelson <anelson at cpan.org>",
  "BUILD_REQUIRES" => {
    "Test::Fatal" => 0,
    "Test::Memory::Cycle" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Data-Riak",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Data::Riak",
  "PREREQ_PM" => {
    "Digest::MD5" => 0,
    "HTTP::Headers" => 0,
    "HTTP::Headers::ActionPack" => 0,
    "HTTP::Headers::ActionPack::LinkHeader" => 0,
    "HTTP::Headers::ActionPack::LinkList" => 0,
    "HTTP::Request" => 0,
    "HTTP::Response" => 0,
    "JSON::XS" => 0,
    "LWP" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "Sub::Exporter" => 0,
    "Test::More" => 0,
    "Try::Tiny" => 0,
    "URI" => 0,
    "URL::Encode" => 0,
    "overload" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.5",
  "test" => {
    "TESTS" => "t/*.t t/buckets/*.t t/link/*.t t/mapreduce/*.t t/result/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



