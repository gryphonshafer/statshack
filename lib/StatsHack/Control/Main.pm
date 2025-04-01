package StatsHack::Control::Main;

use exact -conf, 'Mojolicious::Controller';

sub home ($self) {
    $self->stash(
        seasons => StatsHack::Model::Season->new->seasons,
        usage   => StatsHack::Model::Memory->new->usage,
    ) if ( $self->stash('user') );
}

1;

=head1 NAME

StatsHack::Control::Main

=head1 DESCRIPTION

This class is a subclass of L<Mojolicious::Controller> and provides handlers
for "Main" actions.

=head1 METHODS

=head2 home

Handler for the home page.

=head1 INHERITANCE

L<Mojolicious::Controller>.
