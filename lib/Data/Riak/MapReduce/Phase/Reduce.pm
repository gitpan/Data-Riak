package Data::Riak::MapReduce::Phase::Reduce;
{
  $Data::Riak::MapReduce::Phase::Reduce::VERSION = '0.7';
}
use Moose;

# ABSTRACT: Reduce phase of a MapReduce

extends 'Data::Riak::MapReduce::Phase::Map';

has phase => (
  is => 'ro',
  isa => 'Str',
  default => 'reduce'
);


1;
__END__
=pod

=head1 NAME

Data::Riak::MapReduce::Phase::Reduce - Reduce phase of a MapReduce

=head1 VERSION

version 0.7

=head1 SYNOPSIS

  my $mp = Data::Riak::MapReduce::Phase::Map->new(
    language => "javascript", # The default
    source => "function(v) { return [ v ] }",
    keep => 1 # The default
  );

=head1 DESCRIPTION

A map/reduce map phase for Data::Riak.  See L<Data::Riak::MapReduce::Phase::Reduce>
for attribute information.

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

