defmodule BoardServerTest do
  alias GameOfLife.Board, as: Board
  alias GameOfLife.BoardServer, as: BoardServer
  use ExUnit.Case

  setup do
    GameOfLife.EventManager.start_link
    :ok
  end

    test "gets new board state" do
      {:ok, pid} = BoardServer.start_link({0,0}, {100,100})
      {:ok, board} = BoardServer.next_board_state(pid)
      assert 1 == board.generation
    end

    test "gets a random board state" do
      {:ok, pid} = BoardServer.start_link({0,0}, {1,1}, [density: 100])
      {:ok, board} = BoardServer.current_board(pid)
      assert %Board{origin: {0,0}, size: {1,1}, alive_cells: MapSet.new([])} == board
    end

  test "gets new board state from defined initial board" do
    board = %Board{size: {5,5},
                alive_cells: MapSet.new([{0,0}, {0,4}, {3,1}, {4,1}, {3,2}]),
                foreign_alive_cells: MapSet.new([{-1,-1}, {-1,0}, {0,-1}, {-1,1}])
              }
    {:ok, pid} = BoardServer.start_link({0,0}, {100,100}, [board: board])
    {_, result_board} = BoardServer.next_board_state(pid)

    expected_board = %{board | alive_cells: MapSet.new([{0,1}, {3,1}, {4,1}, {3,2}, {4,2}]), generation: 1}
    assert expected_board == result_board
  end

  test "gets new board state multiple times" do
    board = %Board{size: {5,5},
              alive_cells: MapSet.new([{0,0}, {0,4}, {3,1}, {4,1}, {3,2}]),
              foreign_alive_cells: MapSet.new([{-1,-1}, {-1,0}, {0,-1}, {-1,1}])
            }

    {:ok, pid} = BoardServer.start_link({0,0}, {100,100},  [board: board])
    BoardServer.next_board_state(pid)
    {_, result_board} = BoardServer.next_board_state(pid)

    expected_board = %{board | alive_cells: MapSet.new([{3,1}, {4,1}, {3,2}, {4,2}, {0,1}]), generation: 2}
    assert expected_board == result_board
  end

  test "update foreign alive cells and get new board" do
    board =  %Board{size: {5,5}, foreign_alive_cells: MapSet.new([{-1,3}, {-1,-1}])}
    bottom_left = {-1,0}
    top_right = {-1,4}
    new_foreign_alive_cells = MapSet.new([{-1,1},{-1,2}])

    {:ok, pid} = BoardServer.start_link({0,0}, {100,100}, [board: board])
    BoardServer.update_foreign_area(pid, bottom_left, top_right, new_foreign_alive_cells)

    expected_board = %{board | foreign_alive_cells: MapSet.new([{-1,1},{-1,2},{-1,-1}])}

    {:ok, result_board} = BoardServer.current_board(pid)
    assert expected_board == result_board
  end
end
