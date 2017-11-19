require_relative 'cursor'
require_relative 'board'
require_relative 'display'
class HumanPlayer

  attr_reader :color

  def initialize(color, board = Board.new, cursor = Cursor.new([0,0], board), display = Display.new(board, cursor))
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
      @display.targeted = false;
      p "#{@color}'s turn'"
      if cursor_pos = @cursor.get_input
        if @cursor.recently_selected?
          @display.targeted = true
          @cursor.add_position(cursor_pos)
        end
        # p @cursor.start_end_pos
        # p @display.targeted?
        if @cursor.both_selected?
          touched_piece = @board[@cursor.touched]
          target_piece = @board[@cursor.target]
          if touched_piece.color == @color && target_piece.color != @color
            @board.move_piece(@cursor.touched, @cursor.target)
            move_made = true
          else
            touched_piece = nil
            target_piece = nil
          end
          @cursor.clear_positions
        end
      end
      system("clear")
      # p move_made
      @display.render_board(cursor_pos, @board)

    end
  end

end
