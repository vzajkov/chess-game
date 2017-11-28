require_relative 'piece'
class Rook < Piece
  include SlidingPiece
  attr_accessor :moved
  def initialize(position, board, color)
    super(position, board, color)
    @symbol = color == :white ? "♖" : "♜"
    @moved = false
  end

  def move_dirs
    [:horizontal]
  end
end
