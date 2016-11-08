defmodule GameOfLife.BoardSynchronizerTest do
  use ExUnit.Case, async: true

  setup do
     {:ok, pid} = GenEvent.start_link([])
     board_pid = self()
     GenEvent.add_handler(pid, GameOfLife.BoardSynchronizer, board_pid)
     [sync_pid: pid, default_size: 4]
  end

  describe "#map_cells_to_board" do
    test "maps the coordinates correctly to north", context do
      cells =  [{0, 0}, {2, 0}, {2,1}]
      mapped_cells = GameOfLife.BoardSynchronizer.map_cells_to_board(cells, "N")
      |> Enum.sort

      assert mapped_cells == [{0, context.default_size}, {2, context.default_size}]
    end

    test "maps the coordinates correctly to east", context do
      cells =  [{0,3}, {0,2}, {2,1}]
      mapped_cells = GameOfLife.BoardSynchronizer.map_cells_to_board(cells, "E")
      |> Enum.sort

      assert mapped_cells == [{context.default_size, 2}, {context.default_size, 3}]
    end

    test "maps the coordinates correctly to south", context do
      cells =  [{0, 3}, {2, 3}, {2,1}]
      mapped_cells = GameOfLife.BoardSynchronizer.map_cells_to_board(cells, "S")
      |> Enum.sort

      assert mapped_cells == [{0, -1}, {2, -1}]
    end

    test "maps the coordinates correctly to west", context do
      cells =  [{2,3}, {3,2}, {3,1}]
      mapped_cells = GameOfLife.BoardSynchronizer.map_cells_to_board(cells, "W")
        |> Enum.sort

      assert mapped_cells == [{-1, 1}, {-1, 2}]
    end

    test "maps the coordinates correctly to north east", context do
      cells =  [{0,0}, {2,2}]
      mapped_cells = GameOfLife.BoardSynchronizer.map_cells_to_board(cells, "NE")

      assert mapped_cells == [{context.default_size, context.default_size}]
    end

    test "maps the coordinates correctly to south east", context do
      cells =  [{0,3}, {2,2}]
      mapped_cells = GameOfLife.BoardSynchronizer.map_cells_to_board(cells, "SE")

      assert mapped_cells == [{context.default_size, -1}]
    end

    test "maps the coordinates correctly to south west", context do
      cells =  [{3,3}, {2,2}]
      mapped_cells = GameOfLife.BoardSynchronizer.map_cells_to_board(cells, "SW")

      assert mapped_cells == [{-1, -1}]
    end

    test "maps the coordinates correctly to north west", context do
      cells =  [{3,0}, {2,2}]
      mapped_cells = GameOfLife.BoardSynchronizer.map_cells_to_board(cells, "NW")

      assert mapped_cells == [{-1, context.default_size}]
    end

    test "no relevant coordinates for update", context do
      cells =  [{7,7}]
      mapped_cells = GameOfLife.BoardSynchronizer.map_cells_to_board(cells, "W")

      assert mapped_cells == []
    end
  end

  describe "#add_neighbour" do
    test "adding a neighbour stores him into the state", context do
      neighbour_pid = self()
      position = "W"
      neighbour = { neighbour_pid, position }
      GameOfLife.BoardSynchronizer.add_neighbour(context.sync_pid, neighbour)

      neighbours = GameOfLife.BoardSynchronizer.neighbours(context.sync_pid)
      assert neighbours[neighbour_pid] == position
    end
  end
end
