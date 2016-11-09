defmodule PatternLoaderTest do
  alias GameOfLife.PatternLoader, as: PatternLoader
  use ExUnit.Case

  test "creates a board with one dead cell" do
    pattern = """
    .
    """

    cells = PatternLoader.load(pattern, {3,3})
    expected_cells = MapSet.new([])
    assert cells == expected_cells
  end

  test "creates a board with one alive cell" do
    pattern = """
    *
    """

    cells = PatternLoader.load(pattern, {3,3})
    expected_cells = MapSet.new([{0,2}])
    assert cells == expected_cells
  end

  test "creates a board with specified pattern" do
    pattern = """
    .*.....
    ...*...
    **..***
    """

    cells = PatternLoader.load(pattern, {10, 10})
    expected_cells = MapSet.new([
      {1,9},
      {3,8},
      {0,7},{1,7},{4,7},{5,7},{6,7}
    ])
    assert cells == expected_cells
  end

end
