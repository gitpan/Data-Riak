package Data::Riak::Exception::ClientError;
{
  $Data::Riak::Exception::ClientError::VERSION = '1.3';
}

use Moose;
use namespace::autoclean;

extends 'Data::Riak::Exception';

has '+message' => (
    default => 'Client error',
);

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Data::Riak::Exception::ClientError

=head1 VERSION

version 1.3

=head1 AUTHORS

=over 4

=item *

Andrew Nelson <anelson at cpan.org>

=item *

Florian Ragwitz <rafl@debian.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
