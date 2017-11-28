require_relative 'piece'

class Queen < Piece
  include SlidingPiece

  def initialize(position, board, color)
    super(position, board, color)
    @symbol = color == :white ? "♕" : "♛"
  end

  def move_dirs
    [:horizontal, :diagonal]
  end
end
