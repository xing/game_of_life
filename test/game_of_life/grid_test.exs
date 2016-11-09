defmodule GameOfLife.GridTest do
  use ExUnit.Case
  alias GameOfLife.Grid
  doctest Grid

  describe "add_board/1" do
    test "returns {0, 0]} on first iteration" do
      grid = %Grid{board_size: {10, 20}}
      {:ok, board_id, grid} = Grid.add_board(grid)

      assert {0, 0} == board_id
      assert [{0, 0}] == grid.boards
    end

    test "returns {10, 0]} on second iteration" do
      grid = %Grid{board_size: {10, 20}}
      {:ok, _board_id, grid} = Grid.add_board(grid)
      {:ok, board_id, grid} = Grid.add_board(grid)

      assert {10, 0} == board_id
      assert [{10, 0}, {0, 0}] == grid.boards
    end
  end
end
