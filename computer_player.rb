require_relative 'board'
require_relative 'display'
require_relative 'cursor'
class ComputerPlayer
  def initialize(color, board = Board.new, cursor = Cursor.new([0,0], board), display = Display.new(board, cursor))
    @color = color
    @board = board
    @display = display
  end

  def play_turn
    move_made = false
    cursor_pos = [0,0]
    while !move_made

      row = rand(0..7)
      col = rand(0..7)

      if @board[[row, col]].color == @color && !@board[[row, col]].valid_moves.empty?
        idx = rand(0..@board[[row, col]].valid_moves.length - 1)
        @board.move_piece([row, col],@board[[row,col]].valid_moves[idx])
        move_made = true
      end
    end
    system("clear")
    @display.render_board(cursor_pos, @board)
  end

end
