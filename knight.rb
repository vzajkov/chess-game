require_relative 'piece'
class Knight < Piece
  include SteppingPiece

  def initialize(position, board, color)
    super(position, board, color)
    @symbol = color == :white ? "♘" : "♞"
  end

  def move_diffs
    [[2, 1], [2, -1], [1, 2], [-1, 2], [-1, -2], [-2, -1], [-2, 1], [1, -2]]
  end
end
