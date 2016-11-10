defmodule GameOfLife.Grid do
  defstruct board_size: nil, boards: [], board_server_pids: %{}

  def add_board(%__MODULE__{boards: []} = grid),
    do: {:ok, {0, 0}, %__MODULE__{grid | boards: [{0, 0}], board_server_pids: %{{0,0} => nil}}}
  def add_board(%__MODULE__{board_size: {w, _h}, boards: [{x, y} | _]} = grid) do
    board_id = {x + w, y}
    new_board_server_pids = Map.put(grid.board_server_pids, board_id, nil)
    {:ok, board_id, %__MODULE__{grid | boards: [board_id | grid.boards], board_server_pids: new_board_server_pids}}
  end

  def add_board(%__MODULE__{} = grid, board_id, board_server_pid) do
    new_board_server_pids = Map.update!(grid.board_server_pids, board_id, fn(x) -> board_server_pid end)
    {:ok, board_id, %{grid | board_server_pids: new_board_server_pids}}
  end
end
