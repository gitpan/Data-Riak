package Data::Riak::MapReduce::Phase;
{
  $Data::Riak::MapReduce::Phase::VERSION = '0.10';
}

use Moose::Role;


has keep => (
    is => 'rw',
    isa => 'Bool',
    predicate => 'has_keep',
);

requires 'pack';

no Moose::Role; 1;
__END__
=pod

=head1 NAME

Data::Riak::MapReduce::Phase

=head1 VERSION

version 0.10

=head1 DESCRIPTION

The Phase role contains common code used by all the Data::Riak::MapReduce
phase classes.

=head1 ATTRIBUTES

=head2 keep

Flag controlling whether the results of this phase are included in the final
result of the map/reduce.

=head1 METHODS

=head2 pack

The C<pack> method is required to be implemented by consumers of this role.

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

