defmodule GameOfLifeTest do
	use ExUnit.Case
	doctest GameOfLife

	test "dead board" do
		previous_board = {{5,5},[]}
		assert previous_board == GameOfLife.get_next_state(previous_board)
	end

	test "one alive cell in the board" do
		previous_board = {{5,5},[{1,1}]}
		expected_board = {{5,5},[]}
		assert expected_board == GameOfLife.get_next_state(previous_board)
	end
end