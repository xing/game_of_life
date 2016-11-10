defmodule GameOfLife.BoardManagerTest do
  use ExUnit.Case, async: true

    setup do
      GameOfLife.EventManager.start_link
      GameOfLife.GridManager.start_link
      :ok
    end

  test "start all child process" do
    {:ok, _} = GameOfLife.BoardManager.start_link
  end
end
