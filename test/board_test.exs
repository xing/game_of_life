defmodule BoardTest do
  use ExUnit.Case
  doctest GameOfLife.Board
  import GameOfLife.Board

  test "is within board" do
    assert is_within_board({4,4},{3,3})
  end

  test "is outside board" do
    refute is_within_board({4,4},{6,3})
  end

  test "is outside board on boundaries" do
    refute is_within_board({4,4},{4,0})
    refute is_within_board({4,4},{4,4})
  end

  test "is a neighbour" do
    current = {5,5}
    candidate = {6,6}
    assert is_alive_neighbour(current,candidate)
  end

  test "is also a neighbour" do
    current = {5,5}
    candidate = {4,5}
    assert is_alive_neighbour(current,candidate)
  end

  test "is not a neighbour" do
    current = {5,5}
    candidate = {6,7}
    refute is_alive_neighbour(current,candidate)
  end

  test "a cell is not a neighbour of himself" do
    current = {5,5}
    candidate = {5,5}
    refute is_alive_neighbour(current,candidate)
  end

  test "a cell does not have alive neighbours if board is dead" do
    board_cells = []
    current_cell = {5,5}
    count = count_alive_neighbours(board_cells, current_cell)
    assert 0 == count
  end

  test "a cell does not have alive neighbours" do
    board_cells = [{2,2}]
    current_cell = {5,5}
    count = count_alive_neighbours(board_cells, current_cell)
    assert 0 == count
  end

  test "a cell has alive neighbours" do
    board_cells = [{4,5}, {6,6}]
    current_cell = {5,5}
    count = count_alive_neighbours(board_cells, current_cell)
    assert 2 == count
  end

  test "a cell should stay alive if it has 2 neighbours" do
    board_cells = [{4,5}, {6,6}]
    current_cell = {5,5}
    assert will_stay_alive(board_cells, current_cell)
  end

  test "a cell should stay alive if it has 3 neighbours" do
    board_cells = [{4,5}, {6,6}, {4,4}]
    current_cell = {5,5}
    assert will_stay_alive(board_cells, current_cell)
  end

  test "a cell should not stay alive if it has >3 neighbours" do
    board_cells = [{4,5}, {6,6}, {4,4}, {5,4}]
    current_cell = {5,5}
    refute will_stay_alive(board_cells, current_cell)
  end

  test "a cell should not stay alive if it has <2 neighbours" do
    board_cells = [{4,5}]
    current_cell = {5,5}
    refute will_stay_alive(board_cells, current_cell)
  end

  test "get neighbours" do
    cell = {5,5}
    neighbour_cell = {6,6}
    assert Enum.member?(get_neighbours(cell), neighbour_cell)
  end

  test "get dead neighbours" do
    board = %GameOfLife.Board{size: {5,5}, alive_cells: %MapSet{}}
    dead_neighbour = [{0,0}]
    assert dead_neighbour == get_dead_neighbours(board,{-1,-1} )
  end

  test "get dead neighbours doesn't return alive cells" do
    board = %GameOfLife.Board{size: {5,5}, alive_cells: MapSet.new [{0,0}]}
    dead_neighbour = []
    assert dead_neighbour == get_dead_neighbours(board,{-1,-1} )
  end

  test "get newborn cells" do
    board = %GameOfLife.Board{size: {5,5}, alive_cells: MapSet.new [{-1,-1}, {-1,0}, {0,-1}]}
    assert MapSet.new([{0,0}]) == get_newborn_cells(board)
  end

  test "get next state of board" do
    board = %GameOfLife.Board{size: {5,5}, alive_cells: MapSet.new([{-1,-1}, {-1,0}, {0,-1}])}
    new_board = %GameOfLife.Board{size: {5,5}, alive_cells: MapSet.new([{0,0}])}
    assert next_board_state(board) == new_board
  end

  test "get next state of board 2" do
    board = %GameOfLife.Board{size: {5,5}, alive_cells: MapSet.new [{-1,-1}, {-1,0}, {0,-1}, {0,0}, {-1,1}, {0,4}, {3,1}, {4,1}, {3,2}]}
    new_board = %GameOfLife.Board{size: {5,5}, alive_cells: MapSet.new [{0,1}, {3,1}, {4,1}, {3,2}, {4,2}]}
    assert next_board_state(board) == new_board
  end
end
