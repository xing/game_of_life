defmodule BoardLoaderTest do
  alias GameOfLife.Board, as: Board
  alias GameOfLife.BoardLoader, as: BoardLoader
  use ExUnit.Case

  test "creates a board with one dead cell" do
    size = {3,3}
    pattern = """
    .
    """

    board = BoardLoader.load(pattern, {3,3})
    expected_board = %Board{size: size}
    assert board == expected_board
  end

  test "creates a board with one alive cell" do
    size = {3,3}
    pattern = """
    *
    """

    board = BoardLoader.load(pattern,size)
    expected_board = %Board{size: size, alive_cells: MapSet.new([{0,2}])}
    assert board == expected_board
  end

  test "creates a board with specified pattern" do
    size = {10,10}
    pattern = """
    .*.....
    ...*...
    **..***
    """

    board = BoardLoader.load(pattern, size)
    alive_cells = MapSet.new([
      {1,9},
      {3,8},
      {0,7},{1,7},{4,7},{5,7},{6,7}
    ])
    expected_board = %Board{size: size, alive_cells: alive_cells}
    assert board == expected_board
  end

end
