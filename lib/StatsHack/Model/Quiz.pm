package StatsHack::Model::Quiz;

use exact -class;
use Mojo::JSON qw( to_json from_json );

with 'Omniframe::Role::Model';

sub freeze ( $self, $data ) {
    $data->{data} = to_json( $data->{data} );
    undef $data->{data} if ( $data->{data} eq '{}' or $data->{data} eq 'null' );
    return $data;
}

sub thaw ( $self, $data ) {
    $data->{data} = ( defined $data->{data} ) ? from_json( $data->{data} ) : {};
    return $data;
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

=head1 WITH ROLE

L<Omniframe::Role::Model>.
