package Data::Riak::MapReduce;
{
  $Data::Riak::MapReduce::VERSION = '1.1';
}

use strict;
use warnings;

# ABSTRACT: A map/reduce query

use Moose;
use Data::Riak::MapReduce::Phase::Link;
use Data::Riak::MapReduce::Phase::Map;
use Data::Riak::MapReduce::Phase::Reduce;

use JSON::XS qw/encode_json/;

with 'Data::Riak::Role::HasRiak';


has inputs => (
    is => 'ro',
    isa => 'ArrayRef | Str | HashRef',
    required => 1
);


has phases => (
    is => 'ro',
    isa => 'ArrayRef[Data::Riak::MapReduce::Phase]',
    required => 1
);


sub mapreduce {
    my ($self, %options) = @_;
  
    return $self->riak->send_request({
        content_type => 'application/json',
        method => 'POST',
        uri => 'mapred',
        data => encode_json({
            inputs => $self->inputs,
            query => [ map { { $_->phase => $_->pack } } @{ $self->phases } ]
        }),
        ($options{'chunked'}
            ? (query => { chunked => 'true' })
            : ()),
    });
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;



=pod

=head1 NAME

Data::Riak::MapReduce - A map/reduce query

=head1 VERSION

version 1.1

=head1 SYNOPSIS

    my $riak = Data::Riak->new;

    my $mr = Data::Riak::MapReduce->new({
        riak => $riak,
        inputs => [ [ "products8", $arg ] ],
        phases => [
            Data::Riak::MapReduce::Phase::Map->new(
                language => "javascript",
                source => "
                function(v) {
                  var m = v.values[0].data.toLowerCase().match(/\w*/g);
                  var r = [];
                  for(var i in m) {
                    if(m[i] != '') {
                      var o = {};
                      o[m[i]] = 1;
                      r.push(o);
                    }
                  }
                  return r;
                }
                ",
            ),
            Data::Riak::MapReduce::Phase::Reduce->new(
                language => "javascript",
                source => "
                function(v) {
                  var r = {};
                  for(var i in v) {
                    for(var w in v[i]) {
                      if(w in r) r[w] += v[i][w];
                      else r[w] = v[i][w];
                    }
                  }
                  return [r];
                }
                ",
            ),
        ]
    });

    my $results = $mr->mapreduce;

=head1 DESCRIPTION

A map/reduce query.

=head1 ATTRIBUTES

=head2 inputs

Inputs to this query.  There are few allowable forms.

For a single bucket:

  inputs => "bucketname"

For a bucket and key (or many!):

  inputs => [ [ "bucketname", "keyname" ] ]

  inputs => [ [ "bucketname", "keyname" ], [ "bucketname", "keyname2" ] ]

And finally:

  inputs => [ [ "bucketname", "keyname", "keyData" ] ]

=head2 phases

An arrayref of phases that will be executed in order.  The phases should be
one of L<Data::Riak::MapReduce::Phase::Link>,
L<Data::Riak::MapReduce::Phase::Map>, or L<Data::Riak::MapReduce::Phase::Reduce>.

=head1 METHODS

=head2 mapreduce

Execute the mapreduce query.

To enable streaming, do the following:

    my $results = $mr->mapreduce(chunked => 1);

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
