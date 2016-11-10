defmodule GameOfLife.Board do
  alias GameOfLife.Board, as: Board
  defstruct(
    generation: 0, # iteration number
    origin: {0,0}, # this is the bottom left corner of the board
    size: {5,5}, # size of board {x,y}
    alive_cells: %MapSet{}, # set of tuples of alive cells e.g. [{1,1}, {5,2}].  Bottom left is 0,0
    foreign_alive_cells: %MapSet{} # set of tuples of alive cells
  )

  @neighbour_range -1..1

  def update_foreign_area(%Board{} = board, bottom_left, top_right, new_foreign_alive_cells \\ %MapSet{}) do
    updated_foreign_alive_cells = clean_foreign_area(board, bottom_left, top_right)
    %{board | foreign_alive_cells: MapSet.union(new_foreign_alive_cells, updated_foreign_alive_cells)}
  end

  def next_board_state(%Board{} = board) do
    # TODO This is a chapu. Try to find a better way.
    combined_board = %{board | alive_cells: MapSet.union(board.alive_cells, board.foreign_alive_cells)}
    new_alive_cells = MapSet.union(survivor_cells(combined_board), newborn_cells(combined_board))
    %{board | alive_cells: new_alive_cells, generation: board.generation + 1}
  end

  defp clean_foreign_area(%Board{} = board, bottom_left, top_right) do
    board.foreign_alive_cells
    |> Enum.filter(&(!within_area?(bottom_left, top_right, &1)))
    |> MapSet.new
  end

  defp survivor_cells(%Board{} = board) do
    board.alive_cells
    |> Enum.filter(&(within_board?(board.origin, board.size, &1) and will_stay_alive?(board.alive_cells, &1)))
    |> MapSet.new
  end

  defp newborn_cells(%Board{} = board) do
    board.alive_cells
    |> Enum.flat_map(&(neighbour_cells(&1))) # getting neighbours of alive cells
    |> Enum.filter(&(will_become_alive?(board, &1)))
    |> MapSet.new
  end

  defp alive_cell?(%Board{} = board, cell) do
    Enum.member?(board.alive_cells, cell)
  end

  defp neighbour_ranges do
    @neighbour_range
    |> Enum.reduce([], fn(x,acc) -> acc ++ Enum.map(@neighbour_range, fn(y) -> {x,y} end) end)
    |> Enum.filter(&(&1 != {0,0}))
  end

  defp neighbour_cells({cell_x, cell_y}) do
    neighbour_ranges()
    |> Enum.map(fn({x,y}) -> {cell_x + x, cell_y + y} end)
  end

  defp will_stay_alive?(board_cells, current_cell) do
    alive_neighbours = count_alive_neighbours(board_cells, current_cell)
    alive_neighbours == 2 or alive_neighbours == 3
  end

  defp will_become_alive?(board, current_cell) do
    if (!alive_cell?(board, current_cell) and within_board?(board.origin, board.size, current_cell)) do
      alive_neighbours = count_alive_neighbours(board.alive_cells, current_cell)
      alive_neighbours == 3
    else
      false
    end
  end

  defp count_alive_neighbours(board_cells, current_cell) do
    Enum.count(board_cells, &(alive_neighbour?(current_cell, &1)))
  end

  defp alive_neighbour?({x_current,y_current} = current_cell, {x_candidate, y_candidate} = candidate) do
    current_cell != candidate and
      abs(x_current - x_candidate) <= 1 and abs(y_current - y_candidate) <= 1
  end

  defp within_board?({origin_x,origin_y} = origin,{size_x,size_y},cell) do
    within_area?(origin,{origin_x + size_x - 1,origin_y + size_y - 1},cell)
  end

  defp within_area?({left_x,bottom_y},{right_x,top_y},{x,y}) do
    x <= right_x and y <= top_y and x >= left_x and y >= bottom_y
  end
end
