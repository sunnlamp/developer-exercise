class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end
end

class Game
  attr_accessor :player_hand, :dealer_hand, :deck
  def initialize
    @player_hand = Hand.new
    @dealer_hand = Hand.new
    @deck = Deck.new
  end

  def deal(player, deck)
    player.cards.push(deck.deal_card)
  end

  def deal_starting_hand(player, dealer, deck)
    2.times do
      deal(player, deck)
      deal(dealer, deck)
    end
  end

  def display_player_hand
    player_hand.cards.each do |card|
      "#{card.name} of #{card.suite}"
    end
  end

  def display_player_total
    @total
    player_hand.cards.each do |card|
      @total += card.value
    end
    return @total
  end

  def print_player_cards
    puts display_player_hand
  end

  def print_player_total
    puts display_player_total
  end

  def bust

  end

end

require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end

  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end

  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end

  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end

  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert(!@deck.playable_cards.include?(card))
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end

class GameTest < Test::Unit::TestCase
  def setup
    @game = Game.new
  end

  def test_game_has_a_deck
    assert_equal @game.deck.playable_cards.size, 52
  end

  def test_game_has_a_player_hand
    @game.deal(@game.player_hand, @game.deck)
    @game.deal(@game.player_hand, @game.deck)
    @cards = []
    @cards << @game.player_hand.cards[0]
    @cards << @game.player_hand.cards[1]

    assert @game.display_player_hand, @card_string
  end

  def test_game_sums_player_card_values
    @game.deal(@game.player_hand, @game.deck)
    @game.deal(@game.player_hand, @game.deck)
    @cards = []
    @cards << @game.player_hand.cards[0]
    @cards << @game.player_hand.cards[1]

    @game.print_player_total

  end

end
