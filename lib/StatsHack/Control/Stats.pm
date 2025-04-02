package StatsHack::Control::Stats;

use exact -conf, 'Mojolicious::Controller';
use StatsHack::Model::Meet;

sub teams ($self) {
    $self->stash( stats => StatsHack::Model::Meet->new->load( $self->param('meet_id') )->stats );
}

sub quizzers ($self) {
    $self->stash( stats => StatsHack::Model::Meet->new->load( $self->param('meet_id') )->stats );
}

1;

=head1 NAME

StatsHack::Control::Stats

=head1 DESCRIPTION

This class is a subclass of L<Mojolicious::Controller> and provides handlers
for "Stats" actions.

=head1 METHODS

=head2 teams

Handler for the teams stats page.

=head2 quizzers

Handler for the quizzers stats page.

=head1 INHERITANCE

L<Mojolicious::Controller>.
