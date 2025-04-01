package StatsHack::Model::Meet;

use exact -class, -conf;
use Mojo::Util 'encode';
use Omniframe::Util::File 'opath';
use StatsHack::Model::Quiz;
use YAML::XS 'Load';

with 'Omniframe::Role::Model';

sub meets ($self) {
    return $self->dq->get('meet')->run->all({});
}

sub draw ($self) {
    return Load( encode( 'UTF-8',
        opath(
            conf->get('meet_draw_files') . '/' . $self->data->{code} . '.yaml'
        )->slurp('UTF-8'),
    ) );
}

sub state ($self) {
    my $state = $self->draw;

    for my $bracket ( $state->{brackets}->@* ) {
        for my $quiz ( $bracket->{quizzes}->@* ) {
            $quiz->{teams} = [
                map {
                    my $team = $_;
                    grep { $_->{name} eq $team } $state->{roster}->@*;
                } $quiz->{teams}->@*
            ];

            try {
                $quiz->{stats} = StatsHack::Model::Quiz->new->load({
                    meet_id => $self->data->{meet_id},
                    bracket => $bracket->{name},
                    name    => $quiz->{name},
                })->data->{stats};
            }
            catch ($e) {}
        }
    }

    return $state;
}

1;

=head1 NAME

StatsHack::Model::Meet

=head1 SYNOPSIS

    use StatsHack::Model::Meet;

=head1 DESCRIPTION

This class is the model for meet objects.

=head1 METHODS

=head2 meets

This method returns a list of meets.

=head2 draw

This method returns the data from the associated meet draw YAML file, located
in the directory specified by the C<meet_draw_files> setting.

=head2 state

This method returns a meet's "state", which is it's draw data with quizzers
from the roster injected into quizzes, and any recorded data included.

=head1 WITH ROLE

L<Omniframe::Role::Model>.
