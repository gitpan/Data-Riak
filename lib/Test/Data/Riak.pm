package Test::Data::Riak;
{
  $Test::Data::Riak::VERSION = '0.10';
}

use strict;
use warnings;

use Try::Tiny;
use Test::More;
use Digest::MD5 qw/md5_hex/;

use Sub::Exporter;

use Data::Riak::HTTP;

my @exports = qw[
    skip_unless_riak
    remove_test_bucket
    create_test_bucket_name
];

Sub::Exporter::setup_exporter({
    exports => \@exports,
    groups  => { default => \@exports }
});

sub create_test_bucket_name {
	my $prefix = shift || 'data-riak-test';
    return $prefix . '-' . md5_hex(scalar localtime)
}

sub skip_unless_riak {
    my $up = Data::Riak::HTTP->new->ping;
    unless($up) {
        plan skip_all => 'Riak did not answer, skipping tests'
    };
    return $up;
}

sub remove_test_bucket {
    my $bucket = shift;

    try {
        $bucket->remove_all;
        Test::More::diag "Removing test bucket so sleeping for a moment to allow riak to eventually be consistent ...";
        my $keys = $bucket->list_keys;
        while ( $keys && @$keys ) {
            sleep(1);
            $keys = $bucket->list_keys;
        }
    } catch {
        is($_->value, "not found\n", "Bucket is now empty");
        is($_->code, "404", "Calling list_keys on an empty bucket gives a 404");
    };
}


__END__
=pod

=head1 NAME

Test::Data::Riak

=head1 VERSION

version 0.10

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

