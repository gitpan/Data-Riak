package Data::Riak::ResultSet;
{
  $Data::Riak::ResultSet::VERSION = '0.9';
}

use strict;
use warnings;

use Moose;

has results => (
    is => 'rw',
    isa => 'ArrayRef[Data::Riak::Result]',
    required => 1
);

sub first { (shift)->results->[0] }

sub all { @{ (shift)->results } }

__PACKAGE__->meta->make_immutable;
no Moose;

1;



=pod

=head1 NAME

Data::Riak::ResultSet

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
