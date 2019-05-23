use v5.10;
use strict;
use warnings;

# Include the "lib" folder when looking for modules
use lib './lib';

use Config::Tiny;
use tsmith::Poker;

sub read_input
{
  my $input_file = shift;
  die("Could not open file '$input_file'!") unless -f $input_file;

  my @input;

  open(my $fh, '<:encoding(UTF-8)', $input_file);
  while (my $name = <$fh>) {
    chomp $name;

    # Replace empty line between games with a more explicit "End of Game" marker.
    if ( $name =~ /^\s*$/ ) {
      push @input, ["EOG"];
      next;
    }

    my $hand = <$fh>; chomp $hand;
    my @cards = split /, */, $hand;
    unshift @cards, $name;
    push @input, \@cards;
  }

  # Make sure the last game is marked, whether the input file ends with an empty line or not.
  push @input, ["EOG"] unless ($input[-1][0] eq "EOG");

  return \@input;
}

# Totally not necessary in perl, but for the sake of mimicing a more pure OO style...
sub main
{
  my $config_file = $ARGV[0] // 'config.ini';
  my $config = Config::Tiny->read($config_file, 'utf8');
  my $input_file = $config->{_}->{'input_file'} // die("No 'input_file' in configuration file '$config_file'!");

  my $input = read_input($input_file);
  my @game_input = undef;
  foreach my $line (@$input) {
    if ( $line->[0] eq 'EOG' ) {
      my $game = tsmith::Poker->new(input => \@game_input);
      my $winner = $game->play_game();
      say "\n$winner! WINS!!\n\n";
      @game_input = undef;
    }
    else {
      my ($head, @tail) = @$line;
      say "$head\n" . join ', ', @tail;
      push @game_input, $line;
    }
  }
}

main();
