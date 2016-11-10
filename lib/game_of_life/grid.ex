defmodule GameOfLife.Grid do
  @default_row_size 3

  defstruct board_size: nil, boards: [], board_server_pids: %{}

  def add_board(%__MODULE__{boards: []} = grid),
    do: {:ok, {0, 0}, %__MODULE__{grid | boards: [{0, 0}]}}

  def add_board(%__MODULE__{board_size: {w, h}, boards: boards} = grid) do
    boards_count = length(boards)
    row_id = rem(boards_count, @default_row_size)
    column_id = trunc(div(boards_count, @default_row_size))

    board_id = {row_id * w, column_id * h}

    {:ok, board_id, %__MODULE__{grid | boards: [board_id | grid.boards]}}
  end

  def set_board_server_pid(%__MODULE__{} = grid, board_id, board_server_pid) do
    new_board_server_pids = Map.put(grid.board_server_pids, board_id, board_server_pid)
    {:ok, board_id, %{grid | board_server_pids: new_board_server_pids}}
  end
end
