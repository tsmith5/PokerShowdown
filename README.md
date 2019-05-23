# PokerHandShowdown

This is an attempt to tackle a simple Poker challenge problem in Perl. It solves the same problem as this repo: https://github.com/Ullas-Gurukumar/PokerHandShowdown

## Unit Testing

None yet. :)

## Assumptions
* First line will be Name of the player and the next line will be there 5 card.
* Each card will be separated with ", "
* There will be a empty line ("") between each game. The next line will be the name of the player in the next game.
* I have done my testing based on the sample data provided in the document, so all my testing contains 3 players with 5 cards each. 
* I'm not checking if there are too many of the same cards in the deck.
* The ranking of the card: 2 < 3 < 4 < 5 < 6 < 7 < 8 < 9 < 10 < J < Q < K < A. Ace is the highest and 2 is the lowers
* The ranking of the suit: D < C < H < S. Diamonds is the lowest and Spades is the highest.
* The ranking of hand: High Card < One Pair < Three of a Kind < Flush (if 2 players have the same hand, it check for each card based on the circumstance)

## Output
![output.png](https://github.com/tsmith5/PokerShowdown/raw/master/output.png)
