package StatsHack::Control;

use exact 'Omniframe::Control';

sub startup ($self) {
    $self->setup( skip => [ qw( document sockets ) ] );

    my $all = $self->routes->under( sub ($c) {
        $c->stash( page => { wrappers => ['page.html.tt'] } );
    } );
    $all->any('/')->to('main#home');
    $all->any('/meet/:meet_id')->to('meet#state');
    $all->any('/meet/:meet_id/record/:bracket_name/:quiz_name')->to('meet#record');
    $all->any( '/meet/:meet_id/stats/' . $_ )->to( 'stats#' . $_ ) for ( qw( teams quizzers ) );
    $all->any( '/*null' => { null => undef } => sub ($c) { $c->redirect_to('/') } );
}

1;

=head1 NAME

StatsHack::Control

=head1 SYNOPSIS

    #!/usr/bin/env perl
    use MojoX::ConfigAppStart;
    MojoX::ConfigAppStart->start;

=head1 DESCRIPTION

This class is a subclass of L<Omniframe::Control> and provides an override to
the C<startup> method such that L<MojoX::ConfigAppStart> (along with its
required C<mojo_app_lib> configuration key) is sufficient to startup a basic
(and mostly useless) web application.

=head1 METHODS

=head2 startup

This is a basic, thin startup method for L<Mojolicious>. This method calls
C<setup> and sets a universal route that renders a basic text message.

=head1 INHERITANCE

L<Omniframe::Control>.
