defmodule GameOfLife.Board do
  alias GameOfLife.Board, as: Board
  defstruct(
    generation: 0, # iteration number
    origin: {0,0}, # this is the bottom left corner of the board
    size: {5,5}, # size of board {x,y}
    alive_cells: %MapSet{}, # set of tuples of alive cells e.g. [{1,1}, {5,2}].  Bottom left is 0,0
    foreign_alive_cells: %MapSet{}, # set of tuples of alive cells
    cell_attributes: %{}
  )

  @neigbour_vectors [{-1,-1}, {-1,0}, {-1,1}, {0,-1}, {0,1}, {1,-1}, {1,0}, {1,1}]

  def update_foreign_area(%Board{} = board, bottom_left, top_right, new_foreign_alive_cells \\ %MapSet{}) do
    updated_foreign_alive_cells = clean_foreign_area(board, bottom_left, top_right)
    %{board | foreign_alive_cells: MapSet.union(new_foreign_alive_cells, updated_foreign_alive_cells)}
  end

  def next_board_state(%Board{} = board) do
    # TODO This is a chapu. Try to find a better way.
    combined_board = %{board | alive_cells: MapSet.union(board.alive_cells, board.foreign_alive_cells)}
    new_alive_cells = MapSet.union(survivor_cells(combined_board), newborn_cells(combined_board))
    new_cell_attributes = update_cell_attributes(board.cell_attributes, new_alive_cells)
    %{board | alive_cells: new_alive_cells, generation: board.generation + 1, cell_attributes: new_cell_attributes}
  end

  defp update_cell_attributes(old_attributes, new_alive_cells) do
    new_alive_cells
    |> Enum.reduce(%{}, &(Map.put(&2,&1,new_attribute(old_attributes,&1))))
  end

  defp new_attribute(old_attributes, cell) do
    if Map.has_key?(old_attributes, cell) do
      %{ age: Map.get(old_attributes, cell).age + 1 }
    else
      %{ age: 1 }
    end
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
    |> Enum.uniq
    |> Enum.filter(&(will_become_alive?(board, &1)))
    |> MapSet.new
  end

  defp alive_cell?(%Board{} = board, cell) do
    MapSet.member?(board.alive_cells, cell)
  end

  defp neighbour_cells({cell_x, cell_y}) do
    @neigbour_vectors
    |> Enum.map(fn({x,y}) -> {cell_x + x, cell_y + y} end)
  end

  defp will_stay_alive?(board_cells, current_cell) do
    alive_neighbours = count_alive_neighbours(board_cells, current_cell)
    alive_neighbours == 2 or alive_neighbours == 3
  end

  defp will_become_alive?(board, current_cell) do
    if (valid_newborn_candidate?(board, current_cell)) do
      count_alive_neighbours(board.alive_cells, current_cell) == 3
    else
      false
    end
  end

  defp valid_newborn_candidate?(board, current_cell) do
    !alive_cell?(board, current_cell) and within_board?(board.origin, board.size, current_cell)
  end

  defp count_alive_neighbours(board_cells, current_cell) do
    neighbour_cells(current_cell)
    |> Enum.count(&(MapSet.member?(board_cells, &1)))
  end

  defp within_board?({origin_x,origin_y} = origin,{size_x,size_y},cell) do
    within_area?(origin,{origin_x + size_x - 1,origin_y + size_y - 1},cell)
  end

  defp within_area?({left_x,bottom_y},{right_x,top_y},{x,y}) do
    x <= right_x and y <= top_y and x >= left_x and y >= bottom_y
  end
end
