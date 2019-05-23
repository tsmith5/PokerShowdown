package tsmith::Poker;

use strictures 2;
use tsmith::Poker::Hand;
use Moo;
use namespace::clean;

has 'input' => (
  is => 'ro',
  isa => sub {
    die "$_[0] is not an arrayref!" unless ref($_[0]) eq 'ARRAY';
  }
);

has 'high_score_value' => (
  is => 'rw',
  default => 0,
);

has 'high_score_name' => (
  is => 'rw'
);

sub play_game
{
  my $self = shift;

  foreach my $turn (@{$self->input})
  {
    my $player_name = shift @$turn;
    my $hand = tsmith::Poker::Hand->new(cards => $turn);
    my $hand_score = $hand->score;

    $self->check_score($player_name, $hand_score);
  }

  return $self->high_score_name;
}

sub check_score
{
  my ($self, $name, $value) = @_;

  if ( $value > $self->high_score_value )
  {
    $self->high_score_name($name);
    $self->high_score_value($value);
  }
}

1;

__END__

=head1 tsmith::Poker

This module takes a hashref in the constructor and has two function: play_game, check_score

It has three attributes: input, high_score_name, high_score_value

=item input

input should be a perl arrayref with the following structure:

  [
    '[ PlayerNameOne, Card1, Card2, Card3, ..., CardN ],
    '[ PlayerNameTwo, Card1, Card2, Card3, ..., CardN ],
    '[ PlayerName..., Card1, Card2, Card3, ..., CardN ],
    '[ PlayerNameN',  Card1, Card2, Card3, ..., CardN ]
  ]

=item high_score_name

The name of the player who currently has the highest scoring hand

=item high_score_name

The value of the current high-scoring player's hand

=item play_game($input)

This sub takes an input hashref and returns a string of the inputs with the winner on a new line.

It accomplishes this by looping through the input array and creating a new tsmith::Poker::Hand object for each player, and then comparing the scores as calculated by that module. Highest score wins.

=item check_score($name, $value)

This sub compares the passed in value to the current $high_score_value and if necessary updates the $high_score_name and $high_score_fields with the passed in fields.

=end
