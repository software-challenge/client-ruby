#require 'Rubyclient'
require_relative '../lib/Rubyclient/game_state'
require_relative '../lib/Rubyclient/move'

class Client < ClientInterface
  attr_accessor :gamestate
  
  def initialize
    
  end
  
  #gets called, when it's your turn
  def getMove
    puts "spielstand: #{self.gamestate.pointsForPlayer(self.gamestate.currentPlayer)} - #{self.gamestate.pointsForPlayer(self.gamestate.otherPlayer)}"
    mov = self.randomMove
    if false && gamestate.currentPlayerColor == PlayerColor::RED #Rubyclient::PlayerColor::RED
      mov = self.fixedMove
    end
    if false
      self.gamestate.perform(Move.new(1, 1), self.gamestate.red)
      self.gamestate.perform(Move.new(3, 2), self.gamestate.red)
      self.gamestate.perform(Move.new(1, 2), self.gamestate.red)
      self.gamestate.perform(Move.new(3, 1), self.gamestate.red)
      puts self.gamestate.board.to_s
      puts self.gamestate.pointsForPlayer(self.gamestate.red)
      puts self.gamestate.board.connections
    end
    if !mov.nil?
      puts 'Zug gefunden: '
      puts mov.to_s
    end

    return mov
  end

  def fixedMove
    if self.gamestate.turn < 24
        return Move.new((self.gamestate.turn/2) % 2 + 2,self.gamestate.turn) #Rubyclient::Move.new((self.gamestate.turn/2) % 2 + 2,self.gamestate.turn)
    else
        return Move.new(1,23) #Rubyclient::Move.new(1,23)
    end
  end

  #choose a random move
  def randomMove
    possibleMoves = self.gamestate.getPossibleMoves
    if possibleMoves.length > 0
      return possibleMoves[SecureRandom.random_number(possibleMoves.length)]
    end
    return nil
  end
end
