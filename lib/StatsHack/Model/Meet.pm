package StatsHack::Model::Meet;

use exact -class;

with 'Omniframe::Role::Model';

sub meets ($self) {
    return $self->dq->get('meet')->run->all({});
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

=head1 WITH ROLE

L<Omniframe::Role::Model>.
