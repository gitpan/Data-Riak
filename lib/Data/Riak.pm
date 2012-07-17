package Data::Riak;
{
  $Data::Riak::VERSION = '0.5';
}
# ABSTRACT: An interface to a Riak server.

use strict;
use warnings;

use Moose;

use JSON::XS qw/decode_json/;

use Data::Riak::Result;
use Data::Riak::ResultSet;
use Data::Riak::Bucket;
use Data::Riak::MapReduce;

use Data::Riak::HTTP;


has transport => (
    is => 'ro',
    isa => 'Data::Riak::HTTP',
    required => 1,
    handles => {
        'ping' => 'ping',
        'base_uri' => 'base_uri'
    }
);

sub send_request {
    my ($self, $request) = @_;

    my $response = $self->transport->send($request);

    if ($response->is_error) {
        die $response;
    }

    my @parts = @{ $response->parts };

    return unless @parts;
    return Data::Riak::ResultSet->new({
        results => [
            map {
                Data::Riak::Result->new({ riak => $self, http_message => $_ })
            } @parts
        ]
    });
}


sub _buckets {
    my $self = shift;
    return decode_json(
        $self->send_request({
            method => 'GET',
            uri => '/buckets',
            query => { buckets => 'true' }
        })->first->value
    );
}


sub bucket {
    my ($self, $bucket_name) = @_;
    return Data::Riak::Bucket->new({
        riak => $self,
        name => $bucket_name
    })
}

sub resolve_link {
    my ($self, $link) = @_;
    $self->bucket( $link->bucket )->get( $link->key );
}

sub linkwalk {
    my ($self, $args) = @_;
    my $object = $args->{object} || die 'You must have an object to linkwalk';
    my $bucket = $args->{bucket} || die 'You must have a bucket for the original object to linkwalk';

    my $request_str = "buckets/$bucket/keys/$object/";
    my $params = $args->{params};

    foreach my $depth (@$params) {
        if(scalar @{$depth} == 2) {
            unshift @{$depth}, $bucket;
        }
        my ($buck, $tag, $keep) = @{$depth};
        $request_str .= "$buck,$tag,$keep/";
    }

    return $self->send_request({
        method => 'GET',
        uri => $request_str
    });
}



__PACKAGE__->meta->make_immutable;
no Moose;

1;

__END__
=pod

=head1 NAME

Data::Riak - An interface to a Riak server.

=head1 VERSION

version 0.5

=head1 SYNOPSIS

    my $riak = Data::Riak->new({
        transport => Data::Riak::HTTP->new({
            host => 'riak.example.com',
            port => '8098',
            timeout => 5
        })
    });

    my $bucket = Data::Riak::Bucket->new({
        name => 'my_bucket',
        riak => $riak
    });

    # Sets the value of "foo" to "bar", in my_bucket.
    $bucket->add('foo', 'bar');

    # Gets the Result object for "foo" in my_bucket.
    my $foo = $bucket->get('foo');

    # Returns "bar"
    my $value = $foo->value;

    # The HTTP status code, 200 on a successful GET.
    my $code = $foo->code;

=head1 DESCRIPTION

Data::Riak is a simple interface to a Riak server. It is not as complete as L<Net::Riak>,
nor does it aim to be; instead, it attempts to make the simple operations very simple,
while still allowing you to do complicated tasks.

=head1 LINKWALKING

One of Riak's notable features is the ability to easily "linkwalk", or traverse
relationships between objects to return relevant resultsets. The most obvious use
of this is "Show me all of the friends of people Bob is friends with", but it has
great potential, and it's the one thing we tried to make really simple with Data::Riak.

    # Add bar to the bucket, and list foo as a buddy.
    $bucket->add('bar', 'value of bar', {
      links => [ Data::Riak::Link->new(
        bucket => $bucket_name, riaktag => 'buddy', key =>'foo'
      ) ]
    });

    # Add foo to the bucket, and list both bar and baz as "not a buddy"
    # create the links via the $bucket object and the bucket will be
    # inferred from the context
    $bucket->add('foo', 'value of foo', {
      links => [
        $bucket->create_link(riaktag => 'not a buddy', key =>'bar'),
        $bucket->create_link(riaktag => 'not a buddy', key =>'baz')
      ]
    });

    # Get everyone in my_bucket who foo thinks is not a buddy.
    $walk_results = $bucket->linkwalk('foo', [ [ 'not a buddy', 1 ] ]);

    # Get everyone in my_bucket who baz thinks is a buddy of baz, get the people they list as not a buddy, and only return those.
    $more_walk_results = $bucket->linkwalk('baz', [ [ 'buddy', 0 ], [ 'not a buddy', 1 ] ]);

    # You can also linkwalk outside of a bucket. The syntax changes, as such:
    $global_walk_results = $riak->linkwalk({
        bucket => 'my_bucket',
        object => 'foo',
        params => [ [ 'other_bucket', 'buddy', 1 ] ]
    });

The bucket passed in on the riak object's linkwalk is the bucket the original target is in, and is used as a default if you only pass two options in the params lists.

=head1 METHODS

=head2 _buckets

Get the list of buckets. This is NOT RECOMMENDED for production systems, as Riak
has to essentially walk the entire database. Here purely as a tool for debugging
and convenience.

=head2 bucket ($name)

Given a C<$name>, this will return a L<Data::Riak::Bucket> object for it.

=head1 ACKNOWLEDGEMENTS

Influenced heavily by L<Net::Riak>.

I wrote the first pass of Data::Riak, but large sections were added/fixed/rewritten to not suck by Stevan Little C<< <stevan at cpan.org> >> and Cory Watson C<< <gphat at cpan.org> >>.

=head1 TODO

Docs, docs, and more docs. The individual modules have a lot of functionality that needs documented.

=head1 COPYRIGHT & LICENSE

This software is copyright (c) 2012 by Infinity Interactive, Inc..

This is free software; you can redistribute it and/or modify it under the same terms as the Perl 5 programming language system itself.

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

