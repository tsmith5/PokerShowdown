package tsmith::Poker::Card;

use strictures 2;
use Moo;
use namespace::clean;

has card  => ( is => 'ro' );
has rank  => ( is => 'ro' );
has suit  => ( is => 'ro' );
has score => ( is => 'ro' );

around BUILDARGS => sub {
  my ($orig, $class, @args) = @_;

  my $card = $args[1];
  my $len = length $card;
  my $rank = substr $args[1], 0, $len-1;
  my $suit = substr $args[1], -1, 1;
  my $score = 0;

  my %rank_map = (
    'k' => 13,
    'q' => 12,
    'j' => 11,
    'a' => 1
  );

  my %suit_map = (
    's' => 4,
    'c' => 3,
    'h' => 2,
    'd' => 1
  );

  die("Invalid Suit!") unless exists $suit_map{lc $suit};

  $score += ( exists $rank_map{lc $rank} ? $rank_map{lc $rank} : $rank );
  $score *= 10;

  $score += $suit_map{lc $suit};

  my %options = (
    card  => $card,
    rank  => $rank,
    suit  => $suit,
    score => $score
  );

  return \%options;
};

1;

__END__

=head2 tsmith::Poker::Card

This module takes an array of cards as its input and provides one attribute, which is calculated during construction: score

=item score

This returns an integer points value of the hand provided.

=item _calculate_score

This converts the card to an integer value using the following formula
Rank * 10 + Suit
Rank is worth the face value of the card, with Jack, Queen, and King being worth 11, 12, and 13 respectively and Ace worth 1.
Suits are worth 1, 2, 3, and 4 points for Diamonds, Hearts, Clubs, and Spades in order.
This results in a return range of 11 for an Ace of Hearts to 134 for a King of Spades.




