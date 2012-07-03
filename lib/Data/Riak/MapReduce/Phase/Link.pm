package Data::Riak::MapReduce::Phase::Link;
{
  $Data::Riak::MapReduce::Phase::Link::VERSION = '0.2';
}
use Moose;

use JSON::XS ();

# ABSTRACT: Link phase of a MapReduce

with ('Data::Riak::MapReduce::Phase');


has bucket => (
    is => 'rw',
    isa => 'Str',
    predicate => 'has_bucket'
);

has phase => (
    is => 'ro',
    isa => 'Str',
    default => 'link'
);


has tag => (
    is => 'rw',
    isa => 'Str',
    predicate => 'has_tag'
);


sub pack {
    my $self = shift;

    my $href = {};

    $href->{keep} = $self->keep ? JSON::XS::true() : JSON::XS::false() if $self->has_keep;
    $href->{bucket} = $self->bucket if $self->has_bucket;
    $href->{tag} = $self->tag if $self->has_tag;

    $href;
}

1;
__END__
=pod

=head1 NAME

Data::Riak::MapReduce::Phase::Link - Link phase of a MapReduce

=head1 VERSION

version 0.2

=head1 SYNOPSIS

  my $lp = Data::Riak::MapReduce::Phase::Link->new(
    bucket=> "foo",
    tag   => "friend",
    keep  => 0
  );

=head1 DESCRIPTION

A map/reduce link phase for Data::Riak

=head1 ATTRIBUTES

=head2 bucket

The name of the bucket from which links should be followed.

=head2 tag

The name of the tag of links that should be followed

=head1 METHODS

=head2 pack

Serialize this link phase.

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

