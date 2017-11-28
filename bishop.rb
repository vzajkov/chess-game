require_relative 'piece'

class Bishop < Piece
  include SlidingPiece

  def initialize(position, board, color)
    super(position, board, color)
      @symbol = color == :white ? "♗" : "♝"
  end

  def move_dirs
    [:diagonal]
  end

end
