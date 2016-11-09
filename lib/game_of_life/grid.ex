defmodule GameOfLife.Grid do
  defstruct board_size: nil, boards: []

  def add_board(%__MODULE__{boards: []} = grid),
    do: {:ok, {0, 0}, %__MODULE__{grid | boards: [{0, 0}]}}
  def add_board(%__MODULE__{board_size: {w, _h}, boards: [{x, y} | _]} = grid) do
    board_id = {x + w, y}
    {:ok, board_id, %__MODULE__{grid | boards: [board_id | grid.boards]}}
  end
end
