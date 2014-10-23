package Data::Riak::Request::WithBucket;
{
  $Data::Riak::Request::WithBucket::VERSION = '1.5';
}

use Moose::Role;
use namespace::autoclean;

with 'Data::Riak::Request';

has bucket_name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

1;

__END__

=pod

=head1 NAME

Data::Riak::Request::WithBucket

=head1 VERSION

version 1.5

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
