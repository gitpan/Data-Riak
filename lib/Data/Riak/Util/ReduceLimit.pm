package Data::Riak::Util::ReduceCount;
{
  $Data::Riak::Util::ReduceCount::VERSION = '0.9';
}
{
  $Data::Riak::Util::ReduceCount::VERSION = '0.9';
}

use strict;
use warnings;

use Moose;

extends 'Data::Riak::MapReduce::Phase::Reduce';

has '+language' => (
    default => 'erlang'
);

has '+function' => (
    default => 'reduce_count_inputs'
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

Data::Riak::Util::ReduceCount

=head1 VERSION

version 0.9

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__