package StatsHack::Control::Meet;

use exact -conf, 'Mojolicious::Controller';
use StatsHack::Model::Meet;

sub state ($self) {
    $self->stash( draw => StatsHack::Model::Meet->new->load( $self->param('meet_id') )->draw );
}

sub record ($self) {
    if ( $self->param('submitted') ) {
        $self->warn( $self->req->params->to_hash );
    }

    $self->stash( state => StatsHack::Model::Meet->new->load( $self->param('meet_id') )->state );
}

1;

=head1 NAME

StatsHack::Control::Meet

=head1 DESCRIPTION

This class is a subclass of L<Mojolicious::Controller> and provides handlers
for "Meet" actions.

=head1 METHODS

=head2 state

Handler for the meet state page.

=head2 record

Handler for the quiz record page.

=head1 INHERITANCE

L<Mojolicious::Controller>.
