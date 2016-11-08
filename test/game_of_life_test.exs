defmodule GameOfLifeTest do
  alias GameOfLife.Board, as: Board
  use ExUnit.Case
  doctest GameOfLife

  test "dead board" do
    previous_board = %Board{size: {5,5}, alive_cells: MapSet.new([])}
    new_board = %{previous_board | generation: 1}
    assert new_board == GameOfLife.next_board_state(previous_board)
  end

  test "one alive cell in the board" do
    previous_board = %Board{size: {5,5}, alive_cells: MapSet.new([{1,1}])}
    expected_board = %Board{size: {5,5}, alive_cells: MapSet.new([]), generation: 1}
    assert expected_board == GameOfLife.next_board_state(previous_board)
  end
end
