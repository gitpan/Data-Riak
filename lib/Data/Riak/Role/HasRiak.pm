package Data::Riak::Role::HasRiak;
{
  $Data::Riak::Role::HasRiak::VERSION = '1.1';
}

use strict;
use warnings;

use Moose::Role;

use Data::Riak;

has riak => (
    is => 'ro',
    isa => 'Data::Riak',
    required => 1
);

no Moose::Role;

1;



=pod

=head1 NAME

Data::Riak::Role::HasRiak

=head1 VERSION

version 1.1

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
