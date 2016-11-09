defmodule GameOfLife.Grid do
  defstruct board_size: nil, boards: []

  def next_free_board([]), do: {0, 0}
  def next_free_board([{x, y} | _]), do: {x + 1, y}
end
