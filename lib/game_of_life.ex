defmodule GameOfLife do
	@spec get_next_state(Board) :: Board
	def get_next_state({board_size,list} = board) do
		new_list = GameOfLife.Board.get_new_active_cells(list, board)
		{board_size, new_list}
	end

end