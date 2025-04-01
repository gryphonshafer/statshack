package StatsHack::Control::Main;

use exact -conf, 'Mojolicious::Controller';
use StatsHack::Model::Meet;

sub home ($self) {
    $self->stash(
        meets => StatsHack::Model::Meet->new->meets,
    );
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
