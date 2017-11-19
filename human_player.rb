require_relative 'cursor'
require_relative 'board'
require_relative 'display'
class HumanPlayer

  attr_reader :color

  def initialize(color, board = Board.new, cursor = Cursor.new([0,0], board), display = Display.new(board))
    @color = color
    @cursor = cursor
    @board = board
    @display = display
    @start_end_pos = []
  end

  def play_turn
    move_made = false
    cursor_pos = nil
    while !move_made
      p "#{@color}'s turn'"
      if cursor_pos = @cursor.get_input
        if @cursor.recently_selected?
          @start_end_pos << cursor_pos
        end
        p @start_end_pos
        if @start_end_pos.length == 2
          touched_piece = @board[@start_end_pos.first]
          target_piece = @board[@start_end_pos.last]
          if touched_piece.color == @color && target_piece.color != @color
            @board.move_piece(@start_end_pos.first, @start_end_pos.last)
            @start_end_pos = []
            move_made = true
          else
            @start_end_pos = []
            touched_piece = nil
            target_piece = nil
          end
        end
      end
      system("clear")
      p move_made
      @display.render_board(cursor_pos, @board)

    end
  end

end
