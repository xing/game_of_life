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

  test "loads a glider with right coordinates" do
    result = PatternLoader.load_pattern(:glider,{10,10},{36, 9})
    assert {11,12} in Enum.sort result
  end


  test "randomize a degenerate board, full" do
    cells = PatternLoader.load_random({0,0}, {1,1}, 100)
    assert cells == MapSet.new([{0,0}])
  end

  test "randomize a degenerate board, empty" do
    cells = PatternLoader.load_random({0,0}, {1,1}, 0)
    assert cells == MapSet.new
  end

  test "randomize a small board" do
    cells = PatternLoader.load_random({0,0}, {2,2}, 100)
    assert cells == MapSet.new([{0,0},{0,1},{1,0},{1,1}])
  end

  test "randomize a small board, non-default origin" do
    cells = PatternLoader.load_random({100,100}, {2,2}, 100)
    assert cells == MapSet.new([{100,100},{100,101},{101,100},{101,101}])
  end

  test "loading a 3x3 x in offset 100,100" do
    cells = PatternLoader.load_pattern(:big_x, {100,100}, {3,3})
    assert MapSet.new([{100, 100}, {100, 102}, {101, 101}, {102, 100}, {102, 102}]) == cells
  end

  test "loading a 4x4 x" do
    cells = PatternLoader.load_pattern(:big_x, {0,0}, {4,4})
    assert MapSet.new([{0, 0}, {0, 3}, {1, 1}, {1, 2}, {2, 1}, {2, 2}, {3, 0}, {3, 3}]) == cells
  end

end
