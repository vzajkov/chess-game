require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'
class Game

def initialize(board, black = HumanPlayer.new(:black, board, Cursor.new([0,0],board)), white = HumanPlayer.new(:white, board, Cursor.new([0,0],board)))
  @board = board
  @players = [white, black]
  @current_player = @players[0]
end

def play
  until game_over
    current_player.play_turn
    switch_players!
  end
end

def current_player
  @players[0]
end

def switch_players!
  @players[0], @players[1] = @players[1], @players[0]
  # p "current player is...#{@players[0].color}"
end

def game_over
  @board.checkmate?(:white) || @board.checkmate?(:black)
end

end
board = Board.new
game = Game.new(board, ComputerPlayer.new(:black, board, cursor = Cursor.new([0,0], board), display = Display.new(board, cursor)))
game.play
