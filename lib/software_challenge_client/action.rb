# encoding: utf-8

# An action is a part of a move. A move can have multiple actions. The specific
# actions are inherited from this Action class which should be considered
# abstract/interface.
class Action
  attr_accessor :order

  # @return [ActionType] Type of the action.
  def type
    raise 'must be overridden'
  end

  def ==(_other)
    raise 'must be overridden'
  end

  def perform!(_gamestate)
    raise 'must be overridden'
  end

  # Helper to make raising InvalidMoveExceptions easier. It is defined in the
  # Action class instead of the Move class because performing individual actions
  # normally trigger invalid moves, not the move itself.
  #
  # @param message [String] Message why the move is invalid.
  # @return Nothing. Raises an exception.
  def invalid(message)
    raise InvalidMoveException.new(message, self)
  end
end

# Ein Vorwärtszug, um spezifizierte Distanz. Verbrauchte Karroten werden mit k =
# (distance * (distance + 1)) / 2 berechnet (Gaußsche Summe)
class Advance < Action
  attr_reader :distance

  def initialize(distance)
    @distance = distance
    @order = 0
  end

  # Perform the action.
  #
  # @param gamestate [GameState] The game state on which the action will be
  # performed. Performing may change the game state. The action is performed for
  # the current player of the game state.
  def perform!(gamestate)
    valid, message = GameRules.is_valid_to_advance(gamestate, distance)
    invalid(message) unless valid
    # perform state changes
    required_carrots = distance * (distance + 1) / 2
    gamestate.current_player.carrots -= required_carrots
    gamestate.current_player.index += distance
    if gamestate.current_field.type == FieldType::HARE
      gamestate.current_player.must_play_card = true
    end
  end

  def type
    :advance
  end

  def ==(other)
    other.type == type && other.distance == distance
  end
end

# Play a card.
class Card < Action
  attr_reader :order

  # only for type TAKE_OR_DROP_CARROTS
  attr_reader :value

  attr_reader :card_type

  def initialize(card_type, order = 0, value = nil)
    @card_type = card_type
    @order = order
    @value = value
  end

  # (see Advance#perform!)
  def perform!(gamestate)
    gamestate.current_player.must_play_card = false
    case card_type
      when CardType::EAT_SALAD
        valid, message = GameRules.is_valid_to_play_eat_salad(gamestate)
        invalid("Das Ausspielen der EAT_SALAD Karte ist nicht möglich. " + message) unless valid
        gamestate.current_player.salads -= 1
        if gamestate.is_first(gamestate.current_player)
          gamestate.current_player.carrots += 10
        else
          gamestate.current_player.carrots += 20
        end
      when CardType::FALL_BACK
        valid, message = GameRules.is_valid_to_play_fall_back(gamestate)
        invalid("Das Ausspielen der FALL_BACK Karte ist nicht möglich. " + message) unless valid
        gamestate.current_player.index = gamestate.other_player.index - 1
        if gamestate.field(gamestate.current_player.index).type == FieldType::HARE
          gamestate.current_player.must_play_card = true
        end
      when CardType::HURRY_AHEAD
        valid, message = GameRules.is_valid_to_play_hurry_ahead(gamestate)
        invalid("Das Ausspielen der HURRY_AHEAD Karte ist nicht möglich. " + message) unless valid
        gamestate.current_player.index = gamestate.other_player.index + 1
        if gamestate.field(gamestate.current_player.index).type == FieldType::HARE
          gamestate.current_player.must_play_card = true
        end
      when CardType::TAKE_OR_DROP_CARROTS
        valid, message = GameRules.is_valid_to_play_take_or_drop_carrots(gamestate, value)
        invalid("Das Ausspielen der TAKE_OR_DROP_CARROTS Karte ist nicht möglich. " + message) unless valid
        gamestate.current_player.carrots += value
      else
        raise "Unknown card type #{card_type.inspect}!"
    end
    gamestate.set_last_action(self)
    gamestate.current_player.cards.delete(self.type)
  end

  def type
    :card
  end

  def ==(other)
    other.card_type == card_type &&
      (card_type != CardType::TAKE_OR_DROP_CARROTS || (other.value == value)) &&
      other.order == order
  end
end

# Ein Aussetzzug. Ist nur erlaubt, sollten keine anderen Züge möglich sei
class Skip < Action
  def initialize(order = 0)
    # skip should only be first and only action
    @order = 0
  end

  def type
    :skip
  end

  def ==(other)
    other.type == type && other.order == order
  end
end

# Eine Salatessen-Aktion. Kann nur auf einem Salatfeld ausgeführt werden. Muss ausgeführt werden,
# ein Salatfeld betreten wird. Nachdem die Aktion ausgefürht wurde, muss das Salatfeld verlassen
# werden, oder es muss ausgesetzt werden.
# Duch eine Salatessen-Aktion wird ein Salat verbraucht und es werden je nachdem ob der Spieler führt
# oder nicht 10 oder 30 Karotten aufgenommen.
class EatSalad < Action
  def initialize(order = 0)
    @order = order
  end

  def type
    :eat_salad
  end

  def ==(other)
    other.type == type && other.order == order
  end
end