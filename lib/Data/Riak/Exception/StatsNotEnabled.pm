package Data::Riak::Exception::StatsNotEnabled;
{
  $Data::Riak::Exception::StatsNotEnabled::VERSION = '1.9';
}

use Moose;
use namespace::autoclean;

extends 'Data::Riak::Exception';

has '+message' => (
    default => 'Unable to retrieve stats. riak_kv_stat is not enabled',
);

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Data::Riak::Exception::StatsNotEnabled

=head1 VERSION

version 1.9

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
