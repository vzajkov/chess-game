require_relative 'piece'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'
require_relative 'bishop'
require_relative 'knight'
require_relative 'rook'
require 'byebug'
class Board
  #attr_reader :board
  def initialize
    @board = Array.new(8) { Array.new(8) { NullPiece.instance } }
    @taken_pieces = []
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
    @board[0] = back_rank(0, :white)
    @board[1] = second_rank(1, :white)
    @board[6] = second_rank(6, :black)
    @board[7] = back_rank(7, :black)
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].valid_moves.include?(end_pos)
      self[start_pos], self[end_pos] = NullPiece.instance, self[start_pos]
      self[end_pos].position = end_pos
    end

    if self[start_pos].class == King && self[end_pos].class == Rook
      if !self[start_pos].moved && !self[end_pos].moved
        if start_pos.first < end_pos.first
          #queenside

        elsif start_pos.first > end_pos.first
          #kingside
        end
      end
    end

    if self[end_pos].class == Pawn && self[end_pos].color == :black && end_pos.first == 0
      promote!(end_pos)
    elsif self[end_pos].class == Pawn && self[end_pos].color == :white && end_pos.first == 7
      promote!(end_pos)
    end
  end

  def castle(color, direction)
    if color == :white && direction == :kingside
      self[[0,1]], self[[0, 3]] = self[[0, 3]], self[[0, 1]]
      self[[0,2]], self[[0, 0]] = self[[0,0]], self[[0,2]]
      self[[0,3]].position = [0,1]
      self[[0,0]].position = [0,2]
    elsif color == :black && direction == :kingside
      self[[7,1]], self[[7, 3]] = self[[7, 3]], self[[7, 1]]
      self[[7,2]], self[[7, 0]] = self[[7,0]], self[[7,2]]
      self[[7,3]].position = [7,1]
      self[[7,0]].position = [7,2]
    elsif color == :white && direction == :queenside
      self[[0,5]], self[[0, 3]] = self[[0, 3]], self[[0, 5]]
      self[[0,4]], self[[0, 7]] = self[[0,7]], self[[0,4]]
      self[[0,3]].position = [0,5]
      self[[0,7]].position = [0,4]
    elsif color == :black && direction == :queenside
      self[[7,5]], self[[7, 3]] = self[[7, 3]], self[[7, 5]]
      self[[7,4]], self[[7, 7]] = self[[7,7]], self[[7,4]]
      self[[7,3]].position = [7,5]
      self[[7,7]].position = [7,4]
    end
  end

  def promote!(pos)
    self[pos] = Queen.new(pos, self, self[pos].color)
  end

  def move_piece!(start_pos, end_pos)
    if self[end_pos].class == NullPiece
      @taken_pieces << nil
      self[start_pos], self[end_pos] = NullPiece.instance, self[start_pos]
      self[start_pos].position = end_pos
    else
      @taken_pieces << self[end_pos]
      self[start_pos], self[end_pos] = NullPiece.instance, self[start_pos]
      self[start_pos].position = end_pos
    end
  end

  def undo_move(start_pos, end_pos)
    popped = @taken_pieces.pop
    if popped == nil
      self[start_pos], self[end_pos] = self[end_pos], NullPiece.instance
      self[end_pos].position = start_pos
    else
      self[start_pos], self[end_pos] = self[end_pos], popped
      self[end_pos].position = start_pos
    end
  end

  def in_bounds(pos)
    pos.all? { |el| (0..7).include?(el) }
  end



  def find_king(color)
    (0..7).each do |row|
      (0..7).each do |col|
        if self[[row, col]].class == King && self[[row, col]].color == color
          return self[[row, col]]
          # p @king
        end
      end
    end
  end

  def in_check?(color)
    @king = find_king(color)

    (0..7).each do |row|
      (0..7).each do |col|
        if self[[row, col]].color != color && self[[row, col]].class != NullPiece
          if self[[row, col]].preliminary_moves.include?(@king.position)
            return true
          end
        end
      end
    end

    return false

  end

  def checkmate?(color)
    return false unless self.in_check?(color)

    (0..7).each do |row|
      (0..7).each do |col|
        if self[[row, col]].color == color
          self[[row, col]].preliminary_moves.each do |pos|
            return false if !self[[row, col]].move_into_check(pos)
            #finish this
          end
        end
      end
    end

   return true
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

# p b
