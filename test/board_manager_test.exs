defmodule GameOfLife.BoardManagerTest do
  use ExUnit.Case, async: true

  test "start all child process" do
    {:ok, _} = GameOfLife.BoardManager.start_link
  end
end
