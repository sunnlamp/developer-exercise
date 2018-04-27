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
    total = 0
    @cards = player_hand.cards
    @cards.each do |card|
      total += card.value
    end
    total
  end

  def print_player_cards
    puts display_player_hand
  end

  def print_player_total
    puts display_player_total
  end

  def display_dealer_card
    card = dealer_hand.cards[0]
    "#{card.name} of #{card.value}"
  end

  def check_for_ace(cards)
    cards.find { |card| :ace }
  end

  def adjust_ace
    total = 0
    @cards = player_hand.cards
    position = @cards.index { |card| card.name == :ace }
    ace = @cards.pop(position - 1)

    @cards.each do |card|
      total += card.value
    end

    if total + 11 > 21

    end

  end

  def dealer_stay
    total = 0
    @cards = dealer_hand.cards
    @cards.each do |card|
      total += card.value
    end
    if total == 17
      true
    else
      false
    end
  end

  def bust
    if display_player_total > 21
      true
    else
      false
    end
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

    assert_equal @game.display_player_hand, @cards
  end

  def test_game_sums_player_card_values
    @game.deal(@game.player_hand, @game.deck)
    @game.deal(@game.player_hand, @game.deck)
    @cards = []
    @cards << @game.player_hand.cards[0]
    @cards << @game.player_hand.cards[1]
    @total = @cards[0].value + @cards[1].value

    assert_equal @game.display_player_total, @total
  end

  def test_game_displays_dealer_first_card
    @game.deal(@game.dealer_hand, @game.deck)
    @game.deal(@game.dealer_hand, @game.deck)

    @game.display_dealer_card
  end

  def test_game_checks_for_a_bust
    @game.player_hand.cards = []
    @game.player_hand.cards << Card.new(:hearts, :jack, 10)
    @game.player_hand.cards << Card.new(:diamonds, :jack, 10)
    @game.player_hand.cards << Card.new(:spades, :seven, 7)

    assert @game.bust
  end

  def test_game_checks_is_dealer_lands_on_17
    @game.dealer_hand.cards << Card.new(:hearts, :jack, 10)
    @game.dealer_hand.cards << Card.new(:diamonds, :seven, 7)

    assert @game.dealer_stay
  end

  def test_game_checks_for_presence_of_ace
    @game.player_hand.cards = []
    @game.player_hand.cards << Card.new(:hearts, :jack, 10)
    @game.player_hand.cards << Card.new(:diamonds, :jack, 10)
    @game.player_hand.cards << Card.new(:diamonds, :ace, [11, 1])

    assert @game.check_for_ace(@game.player_hand.cards)
  end

  def test_game_modifies_ace_based_on_total_of_hand
    @game.player_hand.cards = []
    @game.player_hand.cards << Card.new(:hearts, :jack, 10)
    @game.player_hand.cards << Card.new(:diamonds, :jack, 10)
    @game.player_hand.cards << Card.new(:diamonds, :ace, [11, 1])
    @game.check_for_ace(@game.player_hand.cards)

    @game.adjust_ace
    # assert @game.display_player_total, 21
  end
end
