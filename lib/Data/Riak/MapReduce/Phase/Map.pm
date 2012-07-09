package Data::Riak::MapReduce::Phase::Map;
{
  $Data::Riak::MapReduce::Phase::Map::VERSION = '0.3';
}
use Moose;
use Moose::Util::TypeConstraints;

use JSON::XS ();

# ABSTRACT: Map phase of a MapReduce

with ('Data::Riak::MapReduce::Phase');


has language => (
  is => 'ro',
  isa => enum([qw(javascript erlang)]),
  required => 1
);


has name => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_name'
);

has phase => (
  is => 'ro',
  isa => 'Str',
  default => 'map'
);


has arg => (
  is => 'ro',
  isa => 'Str|HashRef',
  predicate => 'has_arg'
);


has source => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_source'
);


sub pack {
  my $self = shift;

  my $href = {};

  $href->{keep} = $self->keep ? JSON::XS::true() : JSON::XS::false() if $self->has_keep;
  $href->{language} = $self->language;
  $href->{name} = $self->name if $self->has_name;
  $href->{source} = $self->source if $self->has_source;
  $href->{arg} = $self->arg if $self->has_arg;

  $href;
}

1;

__END__
=pod

=head1 NAME

Data::Riak::MapReduce::Phase::Map - Map phase of a MapReduce

=head1 VERSION

version 0.3

=head1 SYNOPSIS

  my $mp = Data::Riak::MapReduce::Phase::Map->new(
    language => "javascript", # The default
    source => "function(v) { return [ v ] }",
    keep => 1 # The default
  );

=head1 DESCRIPTION

A map/reduce map phase for Data::Riak

=head1 ATTRIBUTES

=head2 keep

Flag controlling whether the results of this phase are included in the final
result of the map/reduce. Defaults to true.

=head2 language

The language used with this phase.  One of C<javascript> or C<erlang>. This
attribute is required.

=head2 name

The name, used with built-in functions provided by Riak such as
C<Riak.mapValues>.

=head2 arg

The static argument passed to the map function.

=head2 source

The source of the function used in this phase.

=head1 METHODS

=head2 pack

Serialize this map phase.

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

