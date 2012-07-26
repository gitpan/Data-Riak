package Data::Riak::HTTP::Request;
{
  $Data::Riak::HTTP::Request::VERSION = '0.10';
}

use strict;
use warnings;

use Moose;

use HTTP::Headers::ActionPack::LinkList;

has method => (
    is => 'ro',
    isa => 'Str',
    default => 'GET'
);

has uri => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

has query => (
    is => 'ro',
    isa => 'HashRef',
    predicate => 'has_query'
);

has data => (
    is => 'ro',
    isa => 'Str',
    default => ''
);

has links => (
    is => 'ro',
    isa => 'HTTP::Headers::ActionPack::LinkList',
    # TODO: make this coerce
    default => sub {
        return HTTP::Headers::ActionPack::LinkList->new;
    }
);

has indexes => (
    is => 'ro',
    isa => 'ArrayRef[HashRef]'
);

has content_type => (
    is => 'ro',
    isa => 'Str',
    default => 'text/plain'
);

has accept => (
    is => 'ro',
    isa => 'Str',
    default => '*/*'
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;



=pod

=head1 NAME

Data::Riak::HTTP::Request

=head1 VERSION

version 0.10

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
