defmodule GameOfLife.Board do
  defstruct(
    generation: 0, # iteration number
    size: {5,5}, # size of board {x,y}
    alive_cells: %MapSet{}, # set of tuples of alive cells e.g. [{1,1}, {5,2}].  Bottom left is 0,0
    foreign_alive_cells: %MapSet{} # set of tuples of alive cells
  )

  @neighbour_range -1..1

  def next_board_state(%GameOfLife.Board{} = board) do
    # TODO This is a chapu. Try to find a better way.
    combined_board = %{board | alive_cells: MapSet.union(board.alive_cells, board.foreign_alive_cells)}
    new_alive_cells = MapSet.union(survivor_cells(combined_board), newborn_cells(combined_board))
    %{board | alive_cells: new_alive_cells, generation: board.generation + 1}
  end

  defp survivor_cells(%GameOfLife.Board{} = board) do
    board.alive_cells
    |> Enum.filter(&(within_board?(board.size, &1) and will_stay_alive?(board.alive_cells, &1)))
    |> MapSet.new
  end

  defp newborn_cells(%GameOfLife.Board{} = board) do
    board.alive_cells
    |> Enum.flat_map(&(newborn_neighbour_cells(board, &1)))
    |> Enum.filter(&(will_become_alive?(board.alive_cells, &1)))
    |> MapSet.new
  end

  defp newborn_neighbour_cells(%GameOfLife.Board{} = board, alive_cell) do
    neighbour_cells(alive_cell)
    |> Enum.filter(&(!alive_cell?(board, &1) and within_board?(board.size,&1)))
  end

  defp alive_cell?(%GameOfLife.Board{} = board, cell) do
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

  defp will_become_alive?(board_cells, current_cell) do
    alive_neighbours = count_alive_neighbours(board_cells, current_cell)
    alive_neighbours == 3
  end

  defp count_alive_neighbours(board_cells, current_cell) do
    Enum.count(board_cells, &(alive_neighbour?(current_cell, &1)))
  end

  defp alive_neighbour?({x_current,y_current} = current_cell, {x_candidate, y_candidate} = candidate) do
    current_cell != candidate and
      abs(x_current - x_candidate) <= 1 and abs(y_current - y_candidate) <= 1
  end

  defp within_board?({size_x,size_y},{x,y}) do
    x < size_x and y < size_y and x >= 0 and y >= 0
  end
end
