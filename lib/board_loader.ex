defmodule GameOfLife.BoardLoader do
  alias GameOfLife.Board, as: Board

  def load(pattern, size) do
    %Board{size: size, alive_cells: alive_cells(pattern, size)}
  end

  def alive_cells(pattern, {_, size_y}) do
    String.split(pattern, "\n", trim: true)
    |> Enum.with_index
    |> Enum.flat_map(fn({pattern_line, index}) -> load_line(pattern_line, size_y - index - 1) end)
    |> MapSet.new
  end

  defp load_line(pattern_line, y_coord) do
    String.graphemes(pattern_line)
    |> Enum.with_index
    |> Enum.filter(&(match?({"*", _}, &1)))
    |> Enum.map(fn({_, x_coord}) -> {x_coord, y_coord} end)
  end

end
