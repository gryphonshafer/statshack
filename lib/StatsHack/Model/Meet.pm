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

sub stats ($self) {
    my $stats = { quizzes => [
        map {
            while ( my $team_name = each $_->{stats}{teams}->%* ) {
                my $team = $_->{stats}{teams}{$team_name};

                $team->{points} = $team->{score} / 10;
                if ( $team->{position} == 1 ) {
                    $team->{points} = 10 if ( $team->{points} < 10 );
                }
                elsif ( $team->{position} == 2 ) {
                    $team->{points} -= 1;
                    $team->{points} = 5 if ( $team->{points} < 5 );
                }
                elsif ( $team->{position} == 3 ) {
                    $team->{points} -= 2;
                    $team->{points} = 1 if ( $team->{points} < 1 );
                }
            }

            while ( my $quizzer_name = each $_->{stats}{quizzers}->%* ) {
                my $quizzer = $_->{stats}{quizzers}{$quizzer_name};

                $quizzer->{points} = $quizzer->{correct} * 20;
                $quizzer->{points} -= ( $quizzer->{incorrect} - 1 ) * 10 if ( $quizzer->{incorrect} );
                $quizzer->{points} += 10 if ( $quizzer->{correct} == 4 and $quizzer->{incorrect} == 0 );
            }

            $_;
        }
        StatsHack::Model::Quiz->new->every_data({
            meet_id => $self->data->{meet_id},
            stats   => \q{ IS NOT NULL },
        })->@*
    ] };

    my $brackets;
    my $type_stats = sub ( $type, $name ) {
        my $node = { name => $name };
        for my $quiz ( grep { $_->{stats}{$type}{ $node->{name} } } $stats->{quizzes}->@* ) {
            my $points = $quiz->{stats}{$type}{ $node->{name} }{points};

            $node->{points} += $points;
            $node->{quizzes}++;

            $node->{by_bracket}{ $quiz->{bracket} }{points} += $points;
            $node->{by_bracket}{ $quiz->{bracket} }{quizzes}++;

            $node->{correct}   += $quiz->{stats}{$type}{ $node->{name} }{correct}   // 0;
            $node->{incorrect} += $quiz->{stats}{$type}{ $node->{name} }{incorrect} // 0;

            $brackets->{ $quiz->{bracket} } = 1;
        }

        $node->{average} = ( $node->{points} and $node->{quizzes} ) ? $node->{points} / $node->{quizzes} : 0;
        $_->{average} = $_->{points} / $_->{quizzes}
            for ( map { $node->{by_bracket}{$_} } keys $node->{by_bracket}->%* );

        return $node;
    };

    my $draw           = $self->draw;
    $stats->{teams}    = [ map { $type_stats->( 'teams', $_->{name} ) } $draw->{roster}->@* ];
    $stats->{quizzers} = [ map { map { $type_stats->( 'quizzers', $_ ) } $_->{quizzers}->@* } $draw->{roster}->@* ];
    $stats->{brackets} = [ sort keys %$brackets ];

    return $stats;
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

=head2 stats

This method calculates and returns a meet's statistics based on any saved quiz
records with C<stats> data.

=head1 WITH ROLE

L<Omniframe::Role::Model>.
