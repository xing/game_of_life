defmodule BoardTest do
	use ExUnit.Case
	doctest GameOfLife.Board

	test "is within board" do
		assert GameOfLife.Board.is_within_board({4,4},{3,3})
	end

	test "is outside board" do
		refute GameOfLife.Board.is_within_board({4,4},{6,3})
	end

	test "is outside board on boundaries" do
		refute GameOfLife.Board.is_within_board({4,4},{4,0})
		refute GameOfLife.Board.is_within_board({4,4},{4,4})
	end

	test "is a neighbour" do
		current = {5,5}
		candidate = {6,6}
		assert GameOfLife.Board.is_alive_neighbour(current,candidate)
	end

	test "is also a neighbour" do
		current = {5,5}
		candidate = {4,5}
		assert GameOfLife.Board.is_alive_neighbour(current,candidate)
	end

	test "is not a neighbour" do
		current = {5,5}
		candidate = {6,7}
		refute GameOfLife.Board.is_alive_neighbour(current,candidate)
	end

	test "a cell is not a neighbour of himself" do
		current = {5,5}
		candidate = {5,5}
		refute GameOfLife.Board.is_alive_neighbour(current,candidate)
	end

	test "a cell does not have alive neighbours if board is dead" do
		board_cells = []
		current_cell = {5,5}
		count = GameOfLife.Board.count_alive_neighbours(board_cells, current_cell)
		assert 0 == count
	end

	test "a cell does not have alive neighbours" do
		board_cells = [{2,2}]
		current_cell = {5,5}
		count = GameOfLife.Board.count_alive_neighbours(board_cells, current_cell)
		assert 0 == count
	end

	test "a cell has alive neighbours" do
		board_cells = [{4,5}, {6,6}]
		current_cell = {5,5}
		count = GameOfLife.Board.count_alive_neighbours(board_cells, current_cell)
		assert 2 == count
	end

	test "a cell should stay alive if it has 2 neighbours" do
		board_cells = [{4,5}, {6,6}]
		current_cell = {5,5}
		assert GameOfLife.Board.will_stay_alive(board_cells, current_cell)
	end

	test "a cell should stay alive if it has 3 neighbours" do
		board_cells = [{4,5}, {6,6}, {4,4}]
		current_cell = {5,5}
		assert GameOfLife.Board.will_stay_alive(board_cells, current_cell)
	end

	test "a cell should not stay alive if it has >3 neighbours" do
		board_cells = [{4,5}, {6,6}, {4,4}, {5,4}]
		current_cell = {5,5}
		refute GameOfLife.Board.will_stay_alive(board_cells, current_cell)
	end

	test "a cell should not stay alive if it has <2 neighbours" do
		board_cells = [{4,5}]
		current_cell = {5,5}
		refute GameOfLife.Board.will_stay_alive(board_cells, current_cell)
	end
end