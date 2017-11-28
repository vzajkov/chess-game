require "singleton"
require 'byebug'

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

  def preliminary_moves
    # p moves
    @prelim_moves = moves.reject do |pos|
      @board[pos].color == self.color
    end

  end

  def valid_moves
    # p moves
    @final_moves = moves.reject do |pos|
      @board[pos].color == self.color || self.move_into_check(pos)
    end

  end

  def move_into_check(end_pos)

    # @board.move_piece!(self.position, end_pos)
    # in_check = @board.in_check?(self.color) ? true : false
    # @board.undo_move(self.position, end_pos)
    # return in_check
    false
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
