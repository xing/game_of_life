defmodule BoardServerTest do
  alias GameOfLife.Board, as: Board
  alias GameOfLife.BoardServer, as: BoardServer
  use ExUnit.Case

  test "gets new board state" do
    {:ok, pid} = BoardServer.start_link(self())
    {_, board} = BoardServer.next_board_state(pid)
    assert 1 == board.generation
  end

  test "gets new board state from defined initial board" do
    board = %Board{size: {5,5},
                alive_cells: MapSet.new([{0,0}, {0,4}, {3,1}, {4,1}, {3,2}]),
                foreign_alive_cells: MapSet.new([{-1,-1}, {-1,0}, {0,-1}, {-1,1}])
              }
    {:ok, pid} = BoardServer.start_link(self(), [board: board])
    {_, result_board} = BoardServer.next_board_state(pid)

    expected_board = %{board | alive_cells: MapSet.new([{0,1}, {3,1}, {4,1}, {3,2}, {4,2}]), generation: 1}
    assert expected_board == result_board
  end

  test "gets new board state multiple times" do
    board = %Board{size: {5,5},
              alive_cells: MapSet.new([{0,0}, {0,4}, {3,1}, {4,1}, {3,2}]),
              foreign_alive_cells: MapSet.new([{-1,-1}, {-1,0}, {0,-1}, {-1,1}])
            }

    {:ok, pid} = BoardServer.start_link(self(), [board: board])
    BoardServer.next_board_state(pid)
    {_, result_board} = BoardServer.next_board_state(pid)

    expected_board = %{board | alive_cells: MapSet.new([{3,1}, {4,1}, {3,2}, {4,2}, {0,1}]), generation: 2}
    assert expected_board == result_board
  end

end
