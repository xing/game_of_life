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
      assert %{} == grid.board_server_pids
    end

    test "returns {10, 0]} on second iteration" do
      grid = %Grid{board_size: {10, 20}}
      {:ok, _board_id, grid} = Grid.add_board(grid)
      {:ok, board_id, grid} = Grid.add_board(grid)

      assert {10, 0} == board_id
      assert [{10, 0}, {0, 0}] == grid.boards
      assert %{} == grid.board_server_pids
    end

    test "returns multiple rows" do
      grid = %Grid{board_size: {10, 20}}

      {:ok, _board_id, grid} = Grid.add_board(grid)
      {:ok, _board_id, grid} = Grid.add_board(grid)
      {:ok, _board_id, grid} = Grid.add_board(grid)
      {:ok, _board_id, grid} = Grid.add_board(grid)
      {:ok, _board_id, grid} = Grid.add_board(grid)
      {:ok, _board_id, grid} = Grid.add_board(grid)
      {:ok, _board_id, grid} = Grid.add_board(grid)
      {:ok, _board_id, grid} = Grid.add_board(grid)
      {:ok, _board_id, grid} = Grid.add_board(grid)

      assert [
        {0,0}, {10,0}, {20,0},
        {0,20}, {10, 20}, {20, 20},
        {0, 40}, {10, 40}, {20,40}] == Enum.reverse(grid.boards)
    end

    test "update board server pids" do
      grid = %Grid{board_size: {10, 20}}
      {:ok, board_id, grid} = Grid.add_board(grid)

      {:ok, _, grid} = Grid.set_board_server_pid(grid, board_id, "hello")

      assert %{{0,0} => "hello"} == grid.board_server_pids
    end
  end
end
