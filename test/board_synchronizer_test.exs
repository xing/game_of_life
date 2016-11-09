defmodule GameOfLife.BoardSynchronizerTest do
  use ExUnit.Case, async: true
  import GameOfLife.BoardSynchronizer, only: [overlapping_cell?: 3]

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
end
