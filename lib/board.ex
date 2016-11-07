defmodule GameOfLife.Board do
  defstruct(
    size: {1,1}, # size of board {x,y}
    alive_cells: [], # list of tuples of alive cells e.g. [{1,1}, {5,2}].  Bottom left is 0,0
  )


	def get_new_active_cells([head|tail], {board_size,board_cells} = board) do
		new_cells = get_new_active_cells(tail,board)
		if is_within_board(board_size,head) and will_stay_alive(board_cells, head) do
			[head|new_cells]
		else
			new_cells
		end
		
	end

	def get_new_active_cells([], _) do
		[]
	end

	def will_stay_alive(board_cells, current_cell) do
		alive_neighbours = count_alive_neighbours(board_cells, current_cell)
		alive_neighbours == 2 or alive_neighbours == 3
	end

	def count_alive_neighbours(board_cells, current_cell) do
		Enum.count(board_cells, fn(x) -> is_alive_neighbour(current_cell, x) end)
	end

	def is_alive_neighbour({x_current,y_current} = current_cell, {x_candidate, y_candidate} = candidate) do
		if current_cell == candidate do
			false
		else
			abs(x_current - x_candidate) <= 1
				and abs(y_current - y_candidate) <= 1
		end
	end

  def is_within_board({size_x,size_y},{x,y}) do
		x < size_x and y < size_y and x >= 0 and y >= 0
  end
end
