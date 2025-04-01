use Test2::V0;
use exact -conf;
use StatsHack::Control;

my $mock = mock 'StatsHack::Control' => (
    override => [ qw( setup_access_log debug info notice warning warn ) ],
);

my $obj;
ok( lives { $obj = StatsHack::Control->new }, 'new' ) or note $@;
isa_ok( $obj, $_ ) for ( 'Mojolicious', 'Omniframe::Control' );
can_ok( $obj, 'startup' );

done_testing;
