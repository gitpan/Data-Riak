package Data::Riak::Link;
{
  $Data::Riak::Link::VERSION = '0.1';
}

use strict;
use warnings;

use Moose;

use URL::Encode qw/url_encode url_decode/;
use HTTP::Headers::ActionPack::LinkHeader;

has bucket => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

has key => (
    is => 'ro',
    isa => 'Str',
    predicate => 'has_key'
);

has riaktag => (
    is => 'ro',
    isa => 'Str',
    predicate => 'has_riaktag'
);

has params => (
    is => 'ro',
    isa => 'HashRef',
    default => sub { +{} }
);

sub from_link_header {
    my ($class, $link_header) = @_;

    my ($bucket, $key, $riaktag);

    # link to another key in riak
    if ($link_header->href =~ /^\/buckets\/(.*)\/keys\/(.*)/) {
        ($bucket, $key) = ($1, $2);
    }
    # link to a bucket
    elsif ($link_header->href =~ /^\/buckets\/(.*)/) {
        $bucket = $1;
    }
    else {
        confess "Incompatible link header URL (" .  $link_header->href . ")";
    }

    my %params = %{ $link_header->params };

    $riaktag = url_decode( delete $params{'riaktag'} )
        if exists $params{'riaktag'};

    $class->new(
        bucket => $bucket,
        ($key ? (key => $key) : ()),
        ($riaktag ? (riaktag => $riaktag) : ()),
        params => \%params
    );
}

sub as_link_header {
    my $self = shift;
    if ($self->has_key) {
        return HTTP::Headers::ActionPack::LinkHeader->new(
            sprintf('/buckets/%s/keys/%s', $self->bucket, $self->key),
            ($self->has_riaktag ? (riaktag => url_encode($self->riaktag)) : ()),
            %{ $self->params }
        );
    }
    else {
        return HTTP::Headers::ActionPack::LinkHeader->new(
            sprintf('/buckets/%s', $self->bucket),
            ($self->has_riaktag ? (riaktag => url_encode($self->riaktag)) : ()),
            %{ $self->params }
        );
    }
}


__PACKAGE__->meta->make_immutable;
no Moose;

1;



=pod

=head1 NAME

Data::Riak::Link

=head1 VERSION

version 0.1

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
