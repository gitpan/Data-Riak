package Data::Riak::Util::MapCount;
{
  $Data::Riak::Util::MapCount::VERSION = '0.5';
}

use strict;
use warnings;

use Moose;

extends 'Data::Riak::MapReduce::Phase::Map';

has '+language' => (
	default => 'erlang'
);

has '+function' => (
    default => 'map_object_value'
);

has '+arg' => (
    default => 'filter_notfound'
);

has '+module' => (
    default => 'riak_kv_mapreduce'
);

no Moose;

1;



=pod

=head1 NAME

Data::Riak::Util::MapCount

=head1 VERSION

version 0.5

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__