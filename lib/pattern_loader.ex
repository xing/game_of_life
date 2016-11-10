defmodule GameOfLife.PatternLoader do

  def load(pattern, {_, size_y}) do
    String.split(pattern, "\n", trim: true)
    |> Enum.with_index
    |> Enum.flat_map(fn({pattern_line, index}) -> load_line(pattern_line, size_y - index - 1) end)
    |> MapSet.new
  end

  def load_random({origin_x, origin_y}, {size_x, size_y}, density \\ 50) do
    Enum.flat_map(0..size_x-1, fn(offset_x) ->
      Enum.map(0..size_y-1, fn(offset_y) ->
        if :rand.uniform(100) <= density do
          {origin_x + offset_x, origin_y + offset_y}
        else
          nil
        end
      end)
    end)
    |> Enum.reject(&(&1 == nil))
    |> MapSet.new
  end

  defp load_line(pattern_line, y_coord) do
    String.graphemes(pattern_line)
    |> Enum.with_index
    |> Enum.filter(&(match?({"*", _}, &1)))
    |> Enum.map(fn({_, x_coord}) -> {x_coord, y_coord} end)
  end

end
