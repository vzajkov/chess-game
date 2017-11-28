require_relative 'piece'
class Pawn < Piece
  def initialize(position, board, color)
    super(position, board, color)
    @symbol = color == :white ? "♙" : "♟"
  end

  def moves
    total_moves = []

    direction = @color == :white ? 1 : -1
    forward = [@position.first + direction, @position.last]

    if @position.first == 1 || @position.first == 6 && self.class === Pawn
      first_move = [@position.first + (2 * direction), @position.last]
      total_moves << first_move if @board[first_move].class == NullPiece
    end

    if @board[forward].class == NullPiece
      total_moves << forward
    end

    [1, -1].each do |d|
      diag = [@position.first + direction, @position.last + d]

      next unless diag.last > 0 && diag.last < 8
      if @board[diag].class != NullPiece && @board[diag].color != self.color
        total_moves << diag
      end
    end
    total_moves

  end
end
