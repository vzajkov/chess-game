require_relative 'piece'
class King < Piece
  include SteppingPiece
  attr_accessor :moved
  def initialize(position, board, color)
    super(position, board, color)
    @symbol = color == :white ? "♔" : "♚"
    @moved = false
  end

  def move_diffs
    [[1, 1], [1, -1], [-1, 1], [-1, -1], [0, 1], [0, -1], [-1, 0], [1, 0]]
  end


end
