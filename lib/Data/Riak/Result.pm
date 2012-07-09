package Data::Riak::Result;
{
  $Data::Riak::Result::VERSION = '0.3';
}

use strict;
use warnings;

use Moose;

use Data::Riak::Link;

use URI;
use HTTP::Headers::ActionPack;

with 'Data::Riak::Role::HasRiak';

has bucket => (
    is => 'ro',
    isa => 'Data::Riak::Bucket',
    lazy => 1,
    default => sub {
        my $self = shift;
        return Data::Riak::Bucket->new({
            name => $self->bucket_name,
            riak => $self->riak
        });
    }
);

has location => (
    is => 'ro',
    isa => 'URI',
    lazy => 1,
    clearer => '_clear_location',
    default => sub {
        my $self = shift;
        return $self->http_message->request->uri if $self->http_message->can('request');
        return URI->new( $self->http_message->header('location') || die "Cannot determine location from " . $self->http_message );
    }
);

has bucket_name => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    default => sub {
        my $self = shift;
        my @uri_parts = split /\//, $self->location->path;
        return $uri_parts[$#uri_parts - 2];
    }
);

has key => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    default => sub {
        my $self = shift;
        my @uri_parts = split /\//, $self->location->path;
        return $uri_parts[$#uri_parts];
    }
);

has links => (
    is => 'rw',
    isa => 'ArrayRef[Data::Riak::Link]',
    lazy => 1,
    clearer => '_clear_links',
    default => sub {
        my $self = shift;
        my $links = $self->http_message->header('link');
        return [] unless $links;
        return [ map {
            Data::Riak::Link->from_link_header( $_ )
        } $links->iterable ];
    }
);

has http_message => (
    is => 'rw',
    isa => 'HTTP::Message',
    required => 1,
    handles => {
        'status_code' => 'code',
        'value' => 'content',
        'header' => 'header',
        'headers' => 'headers',
        # curried delegation
        'etag' => [ 'header' => 'etag' ],
        'content_type' => [ 'header' => 'content-type' ],
        'vector_clock' => [ 'header' => 'x-riak-vclock' ],
        'last_modified' => [ 'header' => 'last_modified' ]
    }
);

sub BUILD {
    my $self = shift;
    HTTP::Headers::ActionPack->new->inflate( $self->http_message->headers );
}

sub create_link {
    my ($self, %opts) = @_;
    return Data::Riak::Link->new({
        bucket => $self->bucket_name,
        key => $self->key,
        riaktag => $opts{riaktag},
        (exists $opts{params} ? (params => $opts{params}) : ())
    });
}

# if it's been changed on the server, discard those changes and update the object
sub sync {
    $_[0] = $_[0]->bucket->get($_[0]->key)
}

# if it's been changed locally, save those changes to the server
sub save {
    my $self = shift;
    return $self->bucket->add($self->key, $self->value, { links => $self->links });
}

sub linkwalk {
    my ($self, $params) = @_;
    return undef unless $params;
    return $self->riak->linkwalk({
        bucket => $self->bucket_name,
        object => $self->key,
        params => $params
    });
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;



=pod

=head1 NAME

Data::Riak::Result

=head1 VERSION

version 0.3

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__