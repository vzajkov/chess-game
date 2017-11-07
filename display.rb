require 'colorize'
require_relative 'cursor'
require_relative 'board'


class Display

  def initialize(board = Board.new)
    @cursor = Cursor.new([0,0], board)
    @board2 = board # temp
    @start_end_pos = []
  end

  def render
    while true
      cursor_pos = nil
      previous_selected = false
      if cursor_pos = @cursor.get_input
        if @cursor.recently_selected?
          @start_end_pos << cursor_pos
        end
        # if @cursor.selected != previous_selected
        #   @start_end_pos << cursor_pos
        #   previous_selected = @cursor.selected
        # end
        if @start_end_pos.length == 2
          @board2.move_piece(@start_end_pos.first, @start_end_pos.last)
          @start_end_pos = []
        end
        system("clear")
        p @start_end_pos
        p @cursor.recently_selected?
        render_board(cursor_pos)
      end

    end
  end

  def render_board(cursor_pos)

    (0..7).each do |col|
      display_col = ""
      (0..7).each do |row|
        piece = @board2[[col,row]]
        placeholder = piece.symbol
        if !@start_end_pos.empty? && [col, row] == @start_end_pos.first
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
  end

end

d = Display.new
d.render
