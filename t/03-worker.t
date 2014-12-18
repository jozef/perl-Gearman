use strict;
use warnings;
use Test::More;

unless ($ENV{GEARMAN_SERVERS}) {
    plan skip_all => 'Gearman::Worker tests without $ENV{GEARMAN_SERVERS}';
    exit;
}

my @servers = split /,/, $ENV{GEARMAN_SERVERS};

use_ok('Gearman::Worker');

my $c = new_ok('Gearman::Worker',
    [job_servers => [split /,/, $ENV{GEARMAN_SERVERS}],]);
isa_ok($c, 'Gearman::Base');

my ($tn) = qw/foo/;
ok($c->register_function($tn => sub { 1; }), "register_function($tn)");
$c->work(
    stop_if => sub { pass("exit work in stop if cb"); done_testing(); exit(); }
);
