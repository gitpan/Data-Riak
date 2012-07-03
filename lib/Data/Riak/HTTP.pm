package Data::Riak::HTTP;
{
  $Data::Riak::HTTP::VERSION = '0.2';
}
# ABSTRACT: An interface to a Riak server, using its HTTP (REST) interface

use strict;
use warnings;

use Moose;

use LWP;
use HTTP::Headers;
use HTTP::Response;
use HTTP::Request;

use Data::Riak::HTTP::Request;
use Data::Riak::HTTP::Response;

use Data::Dump;


has host => (
    is => 'ro',
    isa => 'Str',
    default => sub {
        $ENV{'DATA_RIAK_HTTP_HOST'} || '127.0.0.1';
    }
);


has port => (
    is => 'ro',
    isa => 'Int',
    default => sub {
        $ENV{'DATA_RIAK_HTTP_PORT'} || '8098';
    }
);


has timeout => (
    is => 'ro',
    isa => 'Int',
    default => sub {
        $ENV{'DATA_RIAK_HTTP_TIMEOUT'} || '15';
    }
);


sub base_uri {
    my $self = shift;
    return sprintf('http://%s:%s/', $self->host, $self->port);
}


sub ping {
    my $self = shift;
    my $response = $self->send({ method => 'GET', uri => 'ping' });
    return 0 unless($response->code eq '200');
    return 1;
}


sub send {
    my ($self, $request) = @_;
    unless(blessed $request) {
        $request = Data::Riak::HTTP::Request->new($request);
    }
    my $response = $self->_send($request);
    return $response;
}

sub _send {
    my ($self, $request) = @_;

    my $uri = URI->new( sprintf('http://%s:%s/%s', $self->host, $self->port, $request->uri) );

    if ($request->has_query) {
        $uri->query_form($request->query);
    }

    my $headers = HTTP::Headers->new(
        ($request->method eq 'GET' ? ('Accept' => $request->accept) : ()),
        ($request->method eq 'POST' || $request->method eq 'PUT' ? ('Content-Type' => $request->content_type) : ()),
    );

    if(my $links = $request->links) {
        $headers->header('Link' => $request->links);
    }

    my $http_request = HTTP::Request->new(
        $request->method => $uri->as_string,
        $headers,
        $request->data
    );

    my $ua = LWP::UserAgent->new(timeout => $self->timeout);

    my $http_response = $ua->request($http_request);

    my $response = Data::Riak::HTTP::Response->new({
        http_response => $http_response
    });

    return $response;
}


__PACKAGE__->meta->make_immutable;
no Moose;

1;

__END__
=pod

=head1 NAME

Data::Riak::HTTP - An interface to a Riak server, using its HTTP (REST) interface

=head1 VERSION

version 0.2

=head1 ATTRIBUTES

=head2 host

The host the Riak server is on. Can be set via the environment variable
DATA_RIAK_HTTP_HOST, and defaults to 127.0.0.1.

=head2 port

The port of the host that the riak server is on. Can be set via the environment
variable DATA_RIAK_HTTP_PORT, and defaults to 8098.

=head2 timeout

The maximum value (in seconds) that a request can go before timing out. Can be set
via the environment variable DATA_RIAK_HTTP_TIMEOUT, and defaults to 15.

=head1 METHODS

=head2 base_uri

The base URI for the Riak server.

=head2 ping

Tests to see if the specified Riak server is answering. Returns 0 for no, 1 for yes.

=head2 send ($request)

Send a Data::Riak::HTTP::Request to the server. If you pass in a hashref, it will
create the Request object for you on the fly.

=head1 ACKNOWLEDGEMENTS

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

