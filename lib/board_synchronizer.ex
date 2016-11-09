# {:ok, pid} = GenEvent.start_link([])
# GenEvent.add_handler(pid, GameOfLife.BoardSynchronizer, self())
# GenEvent.notify(pid, {:cells, [{1,2}, {3,4}, {3,3}])

defmodule GameOfLife.BoardSynchronizer do
  use GenEvent

  @default_size 4

  defstruct board_pid: nil, neighbours: %{}

  # Client

  def neighbours(pid) do
    GenEvent.call(pid, __MODULE__, :neighbours)
  end

  def add_neighbour(pid, {board_pid, orientation}) do
    GenEvent.call(pid, __MODULE__, {:add_neighbour, {board_pid, orientation}})
  end

  # Server

  def init(board_pid) do
    {:ok, %GameOfLife.BoardSynchronizer{board_pid: board_pid}}
  end

  def handle_event({:cells_update, cells, pid}, state) do
    orientation = state.neighbours[pid]
    updated_cells = map_cells_to_board(cells, orientation)
    area = get_area(orientation)

    send(state.board_pid, {:update_area,[area, updated_cells]})
    {:ok, state}
  end

  def handle_call({:add_neighbour, {board_pid, orientation}}, state) do
    neighbours = Map.put(state.neighbours, board_pid, orientation)
    new_state = %{state | neighbours: neighbours}
    {:ok, state, new_state}
  end

  def handle_call(:neighbours, state) do
    {:ok, state.neighbours, state}
  end

  defp get_area("N"), do: [{0, @default_size}, {@default_size - 1, @default_size}]
  defp get_area("E"), do: [{@default_size, 0}, {@default_size, @default_size - 1}]
  defp get_area("S"), do: [{0, -1}, {@default_size -1, -1}]
  defp get_area("W"), do: [{-1, 0}, {-1, @default_size - 1}]
  defp get_area("NE"), do: [{@default_size, @default_size}, {@default_size, @default_size}]
  defp get_area("SE"), do: [{@default_size, -1}, {@default_size, -1}]
  defp get_area("SW"), do: [{-1, -1}, {-1, -1}]
  defp get_area("NW"), do: [{-1, @default_size}, {-1, @default_size}]

  def map_cells_to_board(cells, orientation) do
    filter_cells(cells, orientation)
    |> transform_cells(orientation)
  end

  defp filter_cells(cells, "N"), do: Enum.filter(cells, fn({_,y}) -> y == 0 end)
  defp filter_cells(cells, "E"), do: Enum.filter(cells, fn({x,_}) -> x == 0 end)
  defp filter_cells(cells, "S"), do: Enum.filter(cells, fn({_,y}) -> y == @default_size - 1 end)
  defp filter_cells(cells, "W"), do: Enum.filter(cells, fn({x,_}) -> x == @default_size - 1 end)
  defp filter_cells(cells, "NE"), do: Enum.filter(cells, fn({0, 0}) -> true; _ -> false end)
  defp filter_cells(cells, "SE"), do: Enum.filter(cells, fn({0, @default_size - 1}) -> true; _ -> false end)
  defp filter_cells(cells, "SW"), do: Enum.filter(cells, fn({@default_size - 1, @default_size - 1}) -> true; _ -> false end)
  defp filter_cells(cells, "NW"), do: Enum.filter(cells, fn({@default_size - 1, 0}) -> true; _ -> false end)


  defp transform_cells(cells, "N"), do: Enum.map(cells, fn({x,_}) -> {x, @default_size} end)
  defp transform_cells(cells, "E"), do: Enum.map(cells, fn({_,y}) -> {@default_size, y} end)
  defp transform_cells(cells, "S"), do: Enum.map(cells, fn({x,_}) -> {x, -1} end)
  defp transform_cells(cells, "W"), do: Enum.map(cells, fn({_,y}) -> {-1, y} end)
  defp transform_cells([_], "NE"), do: [{@default_size, @default_size}]
  defp transform_cells([_], "SE"), do: [{@default_size, -1}]
  defp transform_cells([_], "SW"), do: [{-1, -1}]
  defp transform_cells([_], "NW"), do: [{-1, @default_size}]

end
