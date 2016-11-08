defmodule BoardTest do
  use ExUnit.Case
  doctest GameOfLife.Board
  import GameOfLife.Board

  # test "a cell should stay alive if it has 2 neighbours" do
  #   board_cells = [{4,5}, {6,6}]
  #   current_cell = {5,5}
  #   assert will_stay_alive?(board_cells, current_cell)
  # end
  #
  # test "a cell should stay alive if it has 3 neighbours" do
  #   board_cells = [{4,5}, {6,6}, {4,4}]
  #   current_cell = {5,5}
  #   assert will_stay_alive?(board_cells, current_cell)
  # end
  #
  # test "a cell should not stay alive if it has >3 neighbours" do
  #   board_cells = [{4,5}, {6,6}, {4,4}, {5,4}]
  #   current_cell = {5,5}
  #   refute will_stay_alive?(board_cells, current_cell)
  # end
  #
  # test "a cell should not stay alive if it has <2 neighbours" do
  #   board_cells = [{4,5}]
  #   current_cell = {5,5}
  #   refute will_stay_alive?(board_cells, current_cell)
  # end

  test "get next state of board" do
    board = %GameOfLife.Board{size: {5,5}, foreign_alive_cells: MapSet.new([{-1,-1}, {-1,0}, {0,-1}])}
    expected_board = %{board | alive_cells: MapSet.new([{0,0}]), generation: 1}
    assert next_board_state(board) == expected_board
  end

  test "get next state of board 2" do
    board = %GameOfLife.Board{size: {5,5},
      alive_cells: MapSet.new([{0,0}, {0,4}, {3,1}, {4,1}, {3,2}]),
      foreign_alive_cells: MapSet.new([{-1,-1}, {-1,0}, {0,-1}, {-1,1}]) }

    new_board = %{board | alive_cells: MapSet.new([{0,1}, {3,1}, {4,1}, {3,2}, {4,2}]), generation: 1}
    assert next_board_state(board) == new_board
  end

  test "generation is incremented by one" do
    board = %GameOfLife.Board{generation: 5}
    new_board = %{board | generation: 6}
    assert next_board_state(board) == new_board
  end

  test "next board state keeps the foreign cells alive" do
    board = %GameOfLife.Board{size: {5,5}, foreign_alive_cells: MapSet.new([{-1,-1}, {-1,0}, {0,-1}])}
    assert board.foreign_alive_cells == next_board_state(board).foreign_alive_cells
  end

end
