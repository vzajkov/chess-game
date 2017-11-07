require "singleton"
module SlidingPiece
  def moves
    total_moves = []
    total_moves += diagonal_moves if move_dirs.include?(:diagonal)
    total_moves += horizontal_moves if move_dirs.include?(:horizontal)
    total_moves
  end

  private

  def diagonal_moves
    moves_array = []
    newpos = @position.dup

    if newpos[0] != 0 && newpos[1] != 0
      newpos[0] -= 1
      newpos[1] -= 1
    end

    until newpos[0] == 0 || newpos[1] == 0 || @board[newpos].class != NullPiece
      newpos[0] -= 1
      newpos[1] -= 1
    end

    (0..7).each do |el|
      # p @board[newpos].class
      next if newpos[0] > 7 || newpos[1] > 7
      break if @board[newpos].class != NullPiece && (newpos != @position && el != 0)
      # p newpos
      moves_array << newpos.dup
      # p moves_array
      newpos[0] += 1
      newpos[1] += 1
    end

    newpos = @position.dup

    if newpos[0] != 0 && newpos[1] != 7
      newpos[0] -= 1
      newpos[1] += 1
    end

    until newpos[0] == 0 || newpos[1] == 7 || @board[newpos].class != NullPiece
      newpos[0] -= 1
      newpos[1] += 1
    end

    (0..7).each do |el|
      next if newpos[0] > 7 || newpos[1] < 0
      break if @board[newpos].class != NullPiece && (newpos != @position && el != 0)
      # p newpos
      moves_array << newpos.dup
      newpos[0] += 1
      newpos[1] -= 1
    end
    # p @position
    # p moves_array
    # sleep(5)
    moves_array
  end

  def horizontal_moves
    moves_array = []
    pos_x = @position.first
    pos_y = @position.last

    array = [0, 7]
    (0..7).each do |x|
      array << x unless @board[[x, pos_y]].class == NullPiece
    end

    lb = array.select { |x| pos_x > x }.max || 0
    ub = array.select { |x| pos_x < x }.min || 7
    #p lb, ub
    # array.each_index.select { |idx| @board[idx, pos_y] != NullPiece.instance }
    (lb..ub).each do |x|
      moves_array << [x, pos_y]
    end

    array = [0, 7]
    (0..7).each do |y|
      array << y unless @board[[pos_x, y]].class == NullPiece
    end

    lb = array.select { |y| pos_y > y }.max || 0
    ub = array.select { |y| pos_y < y }.min || 7
    # array.each_index.select { |idx| @board[idx, pos_y] != NullPiece.instance }
    (lb..ub).each do |y|
      moves_array << [pos_x, y]
    end

    # (0..7).each do |el|
    #   moves_array << [@position.first, el]
    #   moves_array << [el, @position.last]
    # end
    moves_array
  end

end

module SteppingPiece
  def moves
    moves_array = []
    move_diffs.each do |move_diff|
      newpos = [@position.first + move_diff.first, @position.last + move_diff.last]
      if (0..7).include?(newpos[0]) && (0..7).include?(newpos[1])
        moves_array << newpos
      end
    end
    moves_array
  end
end

class Piece
  attr_reader :symbol, :color
  attr_accessor :position

  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
  end

  def valid_moves
    # p moves
    moves_into_check = []

    final_moves = moves.select do |pos|
      @board[pos].color != self.color
    end

    # final_moves.each do |pos|
    #   dup = @board.dup
    #   dup.move_piece(self.position, pos)
    #   moves_into_check << pos if d.in_check?(self.color)    #
    # end

    final_moves.reject {|pos| moves_into_check.include?(pos)}
    return final_moves

  end

end

class Pawn < Piece
  def initialize(position, board, color)
    super(position, board, color)
    @symbol = color == :white ? "♙" : "♟"
  end

  def moves
    total_moves = []

    direction = @color == :white ? 1 : -1
    forward = [@position.first + direction, @position.last]

    if @position.first == 1 || @position.first == 6
      first_move = [@position.first + (2 * direction), @position.last]
      total_moves << first_move if @board[first_move].class == NullPiece
    end

    if @board[forward].class == NullPiece
      total_moves << forward
    end

    # diag_1 = [@position.first + direction, @position.last + 1]
    # if @board[diag_1].class != NullPiece && @board[diag_1].color != self.color
    #   total_moves << diag_1
    # end
    #
    # diag_2 = [@position.first + direction, @position.last - 1]
    # if @board[diag_2].class != NullPiece && @board[diag_2].color != self.color
    #   total_moves << diag_2
    # end
    # total_moves

    [1, -1].each do |d|
      diag = [@position.first + direction, @position.last + d]
      # p diag.last
      # p self.color
      # #p @board[diag]
      # p @board[diag].color
      # p @board[diag].class
      next unless diag.last > 0 && diag.last < 8
      # p diag
      if @board[diag].class != NullPiece && @board[diag].color != self.color
        total_moves << diag
        # p total_moves
      end
    end
    total_moves



    # total_moves = [@color == :white ?
    #   [@position.first + 1, @position.last] : [@position.first - 1, @position.last]
    # ]

  end
end

class King < Piece
  include SteppingPiece

  def initialize(position, board, color)
    super(position, board, color)
    @symbol = color == :white ? "♔" : "♚"
  end

  def move_diffs
    [[1, 1], [1, -1], [-1, 1], [-1, -1], [0, 1], [0, -1], [-1, 0], [1, 0]]
  end


end

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

class Rook < Piece
  include SlidingPiece

  def initialize(position, board, color)
    super(position, board, color)
    @symbol = color == :white ? "♖" : "♜"
  end

  def move_dirs
    [:horizontal]
  end
end

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

class NullPiece < Piece
  include Singleton

  def initialize(color = :n, symbol = " ")
    @color = color
    @symbol = symbol
  end

  def valid_moves
    return []
  end
end
