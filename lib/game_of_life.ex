defmodule GameOfLife do
	@spec get_next_state(Board) :: Board
	def get_next_state(%GameOfLife.Board{} = board) do
		new_list = GameOfLife.Board.get_new_active_cells(board.alive_cells, board)
		%GameOfLife.Board{size: board.size, alive_cells: new_list}
	end

end