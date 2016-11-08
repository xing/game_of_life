defmodule BoardTest do
  alias GameOfLife.Board, as: Board
  use ExUnit.Case
  doctest Board
  import Board

  test "a cell should stay alive if it has 2 neighbours" do
    board = %Board{size: {5,5}, alive_cells: MapSet.new([{0,0}, {1,1}, {2,2}])}
    assert Enum.member?(next_board_state(board).alive_cells, {1,1})
  end

  test "a cell should stay alive if it has 3 neighbours" do
    board = %Board{size: {5,5}, alive_cells: MapSet.new([{0,0}, {1,1}, {2,2}, {2,0}])}
    assert Enum.member?(next_board_state(board).alive_cells, {1,1})
  end

  test "a cell should not stay alive if it has >3 neighbours" do
    board = %Board{size: {5,5}, alive_cells: MapSet.new([{0,0}, {0,1}, {1,1}, {1,0}, {2,0}])}
    refute Enum.member?(next_board_state(board).alive_cells, {1,0})
  end

  test "a new cell is born if it has exactly 3 neighbours" do
    board = %Board{size: {5,5}, alive_cells: MapSet.new([{0,0}, {1,1}, {2,0}])}
    assert Enum.member?(next_board_state(board).alive_cells, {1,0})
  end

  test "a cell should not stay alive if it has <2 neighbours" do
    board = %Board{size: {5,5}, alive_cells: MapSet.new([{0,0}, {2,2}])}
    expected_board =  %{board | alive_cells: MapSet.new([]), generation: 1}
    assert expected_board == next_board_state(board)
  end

  test "get next state of board" do
    board = %Board{size: {5,5}, foreign_alive_cells: MapSet.new([{-1,-1}, {-1,0}, {0,-1}])}
    expected_board = %{board | alive_cells: MapSet.new([{0,0}]), generation: 1}
    assert next_board_state(board) == expected_board
  end

  test "get next state of board 2" do
    board = %Board{size: {5,5},
      alive_cells: MapSet.new([{0,0}, {0,4}, {3,1}, {4,1}, {3,2}]),
      foreign_alive_cells: MapSet.new([{-1,-1}, {-1,0}, {0,-1}, {-1,1}]) }

    new_board = %{board | alive_cells: MapSet.new([{0,1}, {3,1}, {4,1}, {3,2}, {4,2}]), generation: 1}
    assert next_board_state(board) == new_board
  end

  test "generation is incremented by one" do
    board = %Board{generation: 5}
    new_board = %{board | generation: 6}
    assert next_board_state(board) == new_board
  end

  test "next board state keeps the foreign cells alive" do
    board = %Board{size: {5,5}, foreign_alive_cells: MapSet.new([{-1,-1}, {-1,0}, {0,-1}])}
    assert board.foreign_alive_cells == next_board_state(board).foreign_alive_cells
  end

end
