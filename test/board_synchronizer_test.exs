defmodule GameOfLife.BoardSynchronizerTest do
  use ExUnit.Case, async: true
  import GameOfLife.BoardSynchronizer

  setup do
   [board_size: {20, 10}, board_id: {20, 10}]
  end

  test "overlapping_cell?", context do
    refute overlapping_cell?({0, 0},   context[:board_id], context[:board_size])
    assert overlapping_cell?({19, 9},  context[:board_id], context[:board_size])
    refute overlapping_cell?({19, 8},  context[:board_id], context[:board_size])
    refute overlapping_cell?({42, 11}, context[:board_id], context[:board_size])
    assert overlapping_cell?({40, 20}, context[:board_id], context[:board_size])
    refute overlapping_cell?({41, 21}, context[:board_id], context[:board_size])
  end

  test "overlapping_area" do
    assert nil == overlapping_area({{0,0}, {10,20}}, {{11, 21}, {30, 41}})
    assert nil == overlapping_area({{11, 21}, {30, 41}}, {{0,0}, {10,20}})
    assert {{5,5}, {10,20}} == overlapping_area({{0,0}, {10,20}}, {{5, 5}, {30, 41}})
    assert {{5,5}, {10,20}} == overlapping_area({{5, 5}, {30, 41}}, {{0,0}, {10,20}})
    assert {{5,5}, {6,6}} == overlapping_area({{0,0}, {10,20}}, {{5, 5}, {6, 6}})
    assert {{5,5}, {6,6}} == overlapping_area({{5, 5}, {6, 6}}, {{0,0}, {10,20}})
  end

  test "board_area_with_margin" do
    assert {{29,-1}, {40,20}} == board_area_with_margin({30,0}, {10,20})
  end

  test "board_area" do
    assert {{30, 0}, {39,19}} == board_area({30,0}, {10,20})
  end
end
