package StatsHack::Model::Quiz;

use exact -class;
use Mojo::JSON qw( to_json from_json );

with 'Omniframe::Role::Model';

sub freeze ( $self, $data ) {
    $data->{stats} = to_json( $data->{stats} );
    undef $data->{stats} if ( $data->{stats} eq '{}' or $data->{stats} eq 'null' );
    return $data;
}

sub thaw ( $self, $data ) {
    $data->{stats} = ( defined $data->{stats} ) ? from_json( $data->{stats} ) : {};
    return $data;
}

sub record ( $self, $payload ) {
    try {
        $self
            ->load({ map { $_ => $payload->{$_} } qw( meet_id bracket name ) })
            ->save({ stats => $payload->{stats} });
    }
    catch ($e) {
        $self->create($payload);
    }
}

1;

=head1 NAME

StatsHack::Model::Quiz

=head1 SYNOPSIS

    use StatsHack::Model::Quiz;

=head1 DESCRIPTION

This class is the model for quiz objects.

=head1 METHODS

=head2 freeze

Likely not used directly, this method is provided such that
L<Omniframe::Role::Model> will JSON-encode the C<data> hashref.

=head2 thaw

Likely not used directly, C<thaw> will JSON-decode the C<data> hashref.

=head2 record

Saves a submitted payload to an existing quiz database row, if it exists, or
otherwise creates a new record.

=head1 WITH ROLE

L<Omniframe::Role::Model>.
