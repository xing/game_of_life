defmodule BoardGeneratorTest do
  alias GameOfLife.Board, as: Board
  use ExUnit.Case
  import GameOfLife.BoardGenerator

  test "gets new board state" do
    pid = GameOfLife.BoardGenerator.new
    new_board = next_board_state(pid)
    assert 1 == new_board.generation
  end

  test "gets new board state from defined initial board" do
    board = %Board{size: {5,5}, alive_cells: MapSet.new [{-1,-1}, {-1,0}, {0,-1}, {0,0}, {-1,1}, {0,4}, {3,1}, {4,1}, {3,2}]}
    expected_board = %Board{size: {5,5}, alive_cells: MapSet.new([{0,1}, {3,1}, {4,1}, {3,2}, {4,2}]), generation: 1}
    pid = GameOfLife.BoardGenerator.new(board)
    assert expected_board == next_board_state(pid)
  end

  test "gets new board state multiple times" do
    board = %Board{size: {5,5}, alive_cells: MapSet.new [{-1,-1}, {-1,0}, {0,-1}, {0,0}, {-1,1}, {0,4}, {3,1}, {4,1}, {3,2}]}
    board_generation_2 = %Board{size: {5,5}, alive_cells: MapSet.new([{3,1}, {4,1}, {3,2}, {4,2}]), generation: 2}

    pid = GameOfLife.BoardGenerator.new(board)
    next_board_state(pid)
    assert board_generation_2 == next_board_state(pid)
  end

end
