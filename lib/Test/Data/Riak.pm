package Test::Data::Riak;
{
  $Test::Data::Riak::VERSION = '1.2';
}

use strict;
use warnings;

use Try::Tiny;
use Test::More;
use Digest::MD5 qw/md5_hex/;

use Sub::Exporter;

use Data::Riak;
use Data::Riak::HTTP;
use namespace::clean;

sub _env_key {
    my ($key, $https) = @_;
    sprintf 'TEST_DATA_RIAK_HTTP%s_%s', ($https ? 'S' : ''), $key;
}

my %defaults = (
    host     => '127.0.0.1',
    port     => 8098,
    timeout  => 15,
    protocol => 'http',
);

for my $opt (keys %defaults) {
    my $code = sub {
        my ($https) = @_;
        my $env_key = _env_key uc $opt, $https;
        exists $ENV{$env_key} ? $ENV{$env_key} : $defaults{$opt}
    };

    no strict 'refs';
    *{"_default_${opt}"} = $code;
}

sub _build_transport {
    my ($args) = @_;

    my $protocol = exists $args->{protocol}
        ? $args->{protocol} : _default_protocol();

    my $https = $protocol eq 'https';
    Data::Riak->new({
        transport => Data::Riak::HTTP->new({
            protocol => $protocol,
            timeout  => (exists $args->{timeout}
                             ? $args->{timeout} : _default_timeout($https)),
            host     => (exists $args->{host}
                             ? $args->{host} : _default_host($https)),
            port     => (exists $args->{port}
                             ? $args->{port} : _default_port($https)),
        }),
    });
}

sub _build_exports {
    my ($self, $meth, $args, $defaults) = @_;

    my $transport = _build_transport($args);

    return {
        riak_transport              => sub { $transport },
        remove_test_bucket          => \&remove_test_bucket,
        create_test_bucket_name     => \&create_test_bucket_name,
        skip_unless_riak            => sub { skip_unless_riak($transport, @_) },
        skip_unless_leveldb_backend => sub {
            skip_unless_leveldb_backend($transport, @_)
        },
    };
}

my $import = Sub::Exporter::build_exporter({
    groups     => { default => \&_build_exports },
    into_level => 1,
});

sub import {
    my ($class, $args) = @_;
    $import->($class, -default => $args);
}

sub create_test_bucket_name {
	my $prefix = shift || 'data-riak-test';
    return sprintf '%s-%s-%s', $prefix, $$, md5_hex(scalar localtime);
}

sub skip_unless_riak {
    my ($transport) = @_;

    my $up = $transport->ping;
    unless($up) {
        plan skip_all => 'Riak did not answer, skipping tests'
    };
    return $up;
}

sub skip_unless_leveldb_backend {
    my ($transport) = @_;

    my $status = try {
        $transport->status;
    }
    catch {
        warn $_;
        plan skip_all => "Failed to identify the Riak node's storage backend";
    };

    plan skip_all => 'This test requires the leveldb Riak storage backend'
        unless $status->{storage_backend} eq 'riak_kv_eleveldb_backend';
    return;
}

sub remove_test_bucket {
    my $bucket = shift;

    try {
        $bucket->remove_all;
        Test::More::diag "Removing test bucket so sleeping for a moment to allow riak to eventually be consistent ..."
              if $ENV{HARNESS_IS_VERBOSE};
        my $keys = $bucket->list_keys;
        while ( $keys && @$keys ) {
            sleep(1);
            $bucket->remove_all;
            $keys = $bucket->list_keys;
        }
    } catch {
        isa_ok $_, 'Data::Riak::Exception';
    };
}

__END__

=pod

=head1 NAME

Test::Data::Riak

=head1 VERSION

version 1.2

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
