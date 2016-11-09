defmodule GameOfLife.GridTest do
  use ExUnit.Case
  alias GameOfLife.Grid
  doctest Grid

  describe "next_free_board/1" do
    test "returns {0, 0]} on first iteration" do
      assert {0, 0} == Grid.next_free_board([])
    end
  end
end
