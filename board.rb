require_relative 'piece'

class Board
  #attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8) { NullPiece.instance } }
    make_starting_grid #temp
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @board[row][col] = piece
  end

  def make_starting_grid
    # TODO: use back_rank and second_rank to make grid
    @board[0] = back_rank(0, :white)
    @board[1] = second_rank(1, :white)
    @board[6] = second_rank(6, :black)
    @board[7] = back_rank(7, :black)

    # @board.map!.with_index do |row, i|
    #   (0..7).map do |col|
      # if [0, 1, 6, 7].include?(i)
      #   row = row.map { |el| Piece.new() } # temp for Piece.new
      # else
      #   row
      # end
    # end
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].valid_moves.include?(end_pos)
      self[start_pos], self[end_pos] = NullPiece.instance, self[start_pos]
      self[end_pos].position = end_pos
    end



    # if self[start_pos].valid_moves() #revisit this
    #   self[start_pos] = nil
    #   self[end_pos] = Piece.new
    # else
    #   raise Error #revisit this
    # end
  end

  def in_bounds(pos)
    pos.all? { |el| (0..7).include?(el) }
  end

  private

  def back_rank(row,color)
    [Rook.new([row, 0], self, color),
      Knight.new([row,1], self, color),
      Bishop.new([row,2], self, color),
      King.new([row,3], self, color),
      Queen.new([row,4], self, color),
      Bishop.new([row,5], self, color),
      Knight.new([row,6], self, color),
      Rook.new([row,7], self, color)
    ]
  end

  def second_rank(row, color)
    [Pawn.new([row, 0], self, color),
    Pawn.new([row,1], self, color),
    Pawn.new([row,2], self, color),
    Pawn.new([row,3], self, color),
    Pawn.new([row,4], self, color),
    Pawn.new([row,5], self, color),
    Pawn.new([row,6], self, color),
    Pawn.new([row,7], self, color)
  ]
  end
end


b = Board.new
b.make_starting_grid

p b
