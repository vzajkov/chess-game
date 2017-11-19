require 'colorize'
require_relative 'cursor'
require_relative 'board'
require 'byebug'

class Display

  def initialize(board = Board.new)
    @cursor = Cursor.new([0,0], board)
    # @board = board
  end

  def targeted?
    # !@cursor.start_end_pos.empty? && [col, row] == @cursor.start_end_pos.first
    false
  end

  def render_board(cursor_pos, board)

    (0..7).each do |col|
      display_col = ""
      (0..7).each do |row|
        piece = board[[col, row]]
        placeholder = piece.symbol
        if targeted?
          placeholder = placeholder.red
        end
        if cursor_pos == [col, row]
          placeholder = "[#{placeholder}]"
        else
          placeholder = " #{placeholder} "
        end
        if (row + col).odd?
          placeholder = placeholder.on_green
        end
        display_col << placeholder
      end
      puts display_col
    end
    puts '--------------'
    p "black in check" if board.in_check?(:black)
    p 'black loses!' if board.checkmate?(:black)
    p "white in check" if board.in_check?(:white)
    p "white loses!" if board.checkmate?(:white)
  end

end

# d = Display.new
# d.render
