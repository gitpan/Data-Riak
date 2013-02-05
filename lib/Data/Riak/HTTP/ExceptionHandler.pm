package Data::Riak::HTTP::ExceptionHandler;
{
  $Data::Riak::HTTP::ExceptionHandler::VERSION = '1.3';
}

use Moose;
use namespace::autoclean;

has honour_request_specific_exceptions => (
    is       => 'ro',
    isa      => 'Bool',
    required => 1,
    builder  => '_build_honour_request_specific_exceptions',
);

has fallback_handlers => (
    traits   => ['Array'],
    isa      => 'ArrayRef[ArrayRef]', # ArrayRef[Tuple[CodeRef,ClassName]]
    required => 1,
    builder  => '_build_fallback_handler',
    handles  => {
        fallback_handlers => 'elements',
    },
);

sub try_handle_exception {
    my ($self, $request, $http_request, $http_response) = @_;

    my $handled = $self->try_handle_request_specific_exception(
        $request, $http_request, $http_response,
    ) if $self->honour_request_specific_exceptions;

    $self->try_handle_exception_fallback(
        $request, $http_request, $http_response,
    ) unless $handled;
}

sub try_handle_request_specific_exception {
    my ($self, $request, $http_request, $http_response) = @_;

    return unless $request->does('Data::Riak::Request::WithHTTPExceptionHandling');
    return unless $request->has_exception_class_for_http_status(
        $http_response->code,
    );

    my $expt_class = $request->exception_class_for_http_status(
        $http_response->code,
    );

    # this status code isn't fatal for this request
    return 1 if !defined $expt_class;

    $expt_class->throw({
        request            => $request,
        transport_request  => $http_request,
        transport_response => $http_response,
    });
}

sub try_handle_exception_fallback {
    my ($self, $request, $http_request, $http_response) = @_;

    for my $h ($self->fallback_handlers) {
        my ($matcher, $expt_class) = @{ $h };

        $expt_class->throw({
            request            => $request,
            transport_request  => $http_request,
            transport_response => $http_response,
        }) if $matcher->($http_response->code);
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Data::Riak::HTTP::ExceptionHandler

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