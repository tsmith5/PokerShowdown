package tsmith::Poker::Hand;

use v5.10;
use strictures 2;
use tsmith::Poker::Card;
use Scalar::Util qw(looks_like_number);
use Moo;
use namespace::clean;

has score => (
  is => 'rwp',
  lazy => 1,
  builder => '_calculate_score'
);

has cards => (
  is => 'ro',
  isa => sub { die "Hand is not an array ref!" unless ref $_[0] eq 'ARRAY'; }
);

sub _calculate_score {
  my ($self, @cards) = @_;

  #  say "Flush: " . $self->_high_multiples('suit', 5);
  #  say "Three of a Kind: " . $self->_high_multiples('rank', 3);
  #  say "One Pair: " . $self->_high_multiples('rank', 2);
  #  say "High Card: " . $self->_high_card;

  return (
    $self->_high_multiples('suit', 5)
    || $self->_high_multiples('rank', 3)
    || $self->_high_multiples('rank', 2)
    || $self->_high_card()
  );
}

sub _high_card {
  my $self = shift;
  my $high_score = 0;

  foreach my $card_string (@{$self->cards}) {
    my $card = tsmith::Poker::Card->new(card => $card_string);
    $high_score = ( $card->score > $high_score ? $card->score : $high_score );
  }

  return $high_score;
}

sub _high_multiples {
  my ($self, $selector, $multiple) = @_;
  my $high_score = 0;
  my %card_hash;

  die("Invalid selector. Must be either 'rank' or 'suit'")
    unless lc $selector eq 'rank' or lc $selector eq 'suit';

  die("Invalid multiples. Must be a positive integer.")
    unless looks_like_number($multiple) and $multiple > 0 and index($multiple, '.') == -1;

  foreach my $card_string (@{$self->cards}) {
    my $card = tsmith::Poker::Card->new(card => $card_string);
    my $key = ( $selector eq 'rank' ? $card->rank : $card->suit );
    $card_hash{$key}{'num_cards'}++;
    $card_hash{$key}{'total_score'}+=$card->score;
  }

  foreach my $key (keys %card_hash)
  {
    my $num_cards = $card_hash{$key}{'num_cards'};
    my $total_score = $card_hash{$key}{'total_score'};
    $high_score = ( $num_cards == $multiple && $total_score > $high_score ? $total_score : $high_score );
  }

  $high_score += $multiple*100 if $high_score > 0;
  return $high_score;
}

1;

__END__

=head2 tsmith::Poker::Card

This module takes an array of cards as its input and provides one attribute, which is calculated during construction: score

=item score

This contains the integer points value of this hand.

=item _calculate_score

Look for different combinations of poker hands and build a total integer score.

=item _high_card

Iterate through the cards and return the integer points value of the highest card in the hand.

=item _high_multiples

Takes two parameters: A string, and an integer.
1. "selector" is either "rank" or "suit" and tells the sub whether to look for multiples based on the card's rank (number) or suit.
2. "multiple" is a positive integer which tells this sub how many of those cards to look for.

It functions by converting the card array into a hash keyed by either the rank or suit of each card and the total points value for the matching cards.
If the hand contains the right number of matching cards this sub returns the total. If there is more than one match (Eg two pair) it will return the highest value of a single pair.




