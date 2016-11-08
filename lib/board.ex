defmodule GameOfLife.Board do
  defstruct(
    size: {1,1}, # size of board {x,y}
    alive_cells: [], # list of tuples of alive cells e.g. [{1,1}, {5,2}].  Bottom left is 0,0
  )

  @neighbour_range -1..1
	
  def next_board_state(%GameOfLife.Board{} = board) do
    %GameOfLife.Board{size: board.size, alive_cells: get_survivor_cells(board, board.alive_cells) ++ get_newborn_cells(board)}
  end

  def get_survivor_cells(%GameOfLife.Board{} = board, [head|tail]) do
		new_cells = get_survivor_cells(board, tail)

    if is_within_board(board.size, head) and will_stay_alive(board.alive_cells, head) do
      [head|new_cells]
		else
			new_cells
		end
	end

	def get_survivor_cells(_, []) do
		[]
	end

  def get_newborn_cells(%GameOfLife.Board{} = board) do
    board.alive_cells
    |> Enum.flat_map(fn(cell) -> get_dead_neighbours(board, cell) end)
    |> MapSet.new
    |> Enum.filter(fn(cell) -> will_become_alive(board.alive_cells, cell) end)
  end

  def get_dead_neighbours(%GameOfLife.Board{} = board, {current_x, current_y} = alive_cell) do
    neighbours = get_neighbours(alive_cell)
    |> Enum.filter(fn(cell) -> !alive_cell?(board, cell) and is_within_board(board.size,cell) end) 
  end

  def alive_cell?(%GameOfLife.Board{} = board, cell) do
    Enum.member?(board.alive_cells, cell)
  end

  def get_neighbour_ranges do
    @neighbour_range
    |> Enum.reduce([], fn(x,acc) -> acc ++ Enum.map(@neighbour_range, fn(y) -> {x,y} end) end)
    |> Enum.filter(fn(x) -> x != {0,0} end)
  end

  def get_neighbours({cell_x, cell_y}) do
    get_neighbour_ranges()
    |> Enum.map(fn({x,y}) -> {cell_x+x, cell_y+y} end)
  end

	def will_stay_alive(board_cells, current_cell) do
		alive_neighbours = count_alive_neighbours(board_cells, current_cell)
		alive_neighbours == 2 or alive_neighbours == 3
	end

  def will_become_alive(board_cells, current_cell) do
    alive_neighbours = count_alive_neighbours(board_cells, current_cell)
    alive_neighbours == 3
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
