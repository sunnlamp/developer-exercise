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

  def display_dealer_card
    card = dealer_hand.cards[0]
    "#{card.name} of #{card.value}"
  end

  def display_dealer_hand
    dealer_hand.cards.each do |card|
      "#{card.name} of #{card.suite}"
    end
  end

  def print_player_cards
    puts display_player_hand
  end

  def print_dealer_card
    puts display_dealer_card
  end

  def print_player_total
    puts total_score
  end

  def total_score(hand)
    total = 0
    cards = hand

    if !check_for_ace?(cards)
      cards.each do |card|
        total += card.value
      end
    end
    if check_for_ace?(cards) == true
      sorted = cards.sort_by { |card| card.name }.reverse
      sorted.pop

      sorted.each do |card|
        total += card.value
      end
      if total < 11
        total += 11
      else
        total += 1
      end
    end
    total
  end

  def check_for_ace?(cards)
    cards.sort_by { |card| card.name }

    return true if cards.find { |card| card.name ==  :ace }
  end

  def find_ace
    return position = player_hand.cards.index { |card| card.name == :ace }
  end

  def dealer_stay(cards)
    return true if total_score(cards) == 17
  end

  def hit_or_stay(cards)
    if !dealer_stay(cards)
      deal(dealer_hand, deck)
    end
  end

  def bust(hand)
    return true if total_score(hand) > 21
  end

  def blackjack(hand)
    return true if total_score(hand) == 21
  end

  def start
    play = true
    game.initialize
    while (play)
      if condition

      end
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
    @game.player_hand.cards = []
    @game.deal(@game.player_hand, @game.deck)
    @game.deal(@game.player_hand, @game.deck)
    @total = @game.total_score(@game.player_hand.cards)

    assert_equal @game.total_score(@game.player_hand.cards), @total
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

    assert @game.bust(@game.player_hand.cards)
  end

  def test_game_checks_if_dealer_lands_on_17
    @game.dealer_hand.cards << Card.new(:hearts, :jack, 10)
    @game.dealer_hand.cards << Card.new(:diamonds, :seven, 7)

    assert @game.dealer_stay(@game.dealer_hand.cards)
  end

  def test_game_hits_if_dealer_lands_on_less_than_17
    @game.dealer_hand.cards << Card.new(:hearts, :jack, 10)
    @game.dealer_hand.cards << Card.new(:diamonds, :six, 6)
    initial_score = @game.total_score(@game.dealer_hand.cards)
    new_score = @game.total_score(@game.hit_or_stay(@game.dealer_hand.cards))

    assert_not_equal initial_score, new_score
  end

  def test_game_checks_for_location_of_ace
    @game.player_hand.cards = []
    @game.player_hand.cards << Card.new(:hearts, :jack, 10)
    @game.player_hand.cards << Card.new(:diamonds, :jack, 10)
    @game.player_hand.cards << Card.new(:diamonds, :ace, [11, 1])

    assert_equal @game.find_ace, 2
  end

  def test_game_counts_ace_as_one
    @game.player_hand.cards = []
    @game.player_hand.cards << Card.new(:hearts, :jack, 10)
    @game.player_hand.cards << Card.new(:diamonds, :jack, 10)
    @game.player_hand.cards << Card.new(:diamonds, :ace, [11, 1])

    assert_equal @game.total_score(@game.player_hand.cards), 21
  end

  def test_game_checks_for_blackjack
    @game.player_hand.cards = []
    @game.player_hand.cards << Card.new(:hearts, :jack, 10)
    @game.player_hand.cards << Card.new(:diamonds, :jack, 10)
    @game.player_hand.cards << Card.new(:diamonds, :ace, [11, 1])

    assert @game.blackjack(@game.player_hand.cards)
  end

  def test_game_check_for_black_with_two_cards
    @game.player_hand.cards = []
    @game.player_hand.cards << Card.new(:diamonds, :jack, 10)
    @game.player_hand.cards << Card.new(:diamonds, :ace, [11, 1])

    assert @game.blackjack(@game.player_hand.cards)
  end

end
