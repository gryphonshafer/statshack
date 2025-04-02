package StatsHack::Control::Meet;

use exact -conf, 'Mojolicious::Controller';
use StatsHack::Model::Meet;
use StatsHack::Model::Quiz;
use Mojo::Util 'url_unescape';

sub roster ($self) {
    $self->stash( draw => StatsHack::Model::Meet->new->load( $self->param('meet_id') )->draw );
}

sub state ($self) {
    $self->stash( state => StatsHack::Model::Meet->new->load( $self->param('meet_id') )->state );
}

sub record ($self) {
    if ( $self->param('submitted') ) {
        my $stats = {};
        $stats->{ $_->{class} }{ $_->{name} }{ $_->{type} } = $_->{value} for (
            map {
                my $param = {};
                @$param{ qw( value class name type ) } = @$_;
                $param;
            }
            grep { @$_ > 2 and ( $_->[1] eq 'quizzers' or $_->[1] eq 'teams' ) }
            map { [ $self->req->param($_), split( /\|/, url_unescape($_) ) ] }
            $self->req->params->names->@*
        );

        StatsHack::Model::Quiz->new->record( {
            meet_id => $self->param('meet_id'),
            bracket => $self->param('bracket_name'),
            name    => $self->param('quiz_name'),
            stats   => $stats,
        } );

        $self->redirect_to(
            '/meet/' . $self->param('meet_id') .
            '/record/' . $self->param('bracket_name') .
            '/' . $self->param('quiz_name')
        );
    }
    else {
        $self->stash( state => StatsHack::Model::Meet->new->load( $self->param('meet_id') )->state );
    }
}

1;

=head1 NAME

StatsHack::Control::Meet

=head1 DESCRIPTION

This class is a subclass of L<Mojolicious::Controller> and provides handlers
for "Meet" actions.

=head1 METHODS

=head2 roster

Handler for the meet roster page.

=head2 state

Handler for the meet state page.

=head2 record

Handler for the quiz record page.

=head1 INHERITANCE

L<Mojolicious::Controller>.
