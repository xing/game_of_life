defmodule GameOfLife.GridManager do
  use GenServer
  alias GameOfLife.Grid

  @default_board_size {60, 30}

  ## Client API

  def start_link(opts \\ []) do
    board_size = Keyword.get(opts, :board_size, @default_board_size)
    GenServer.start_link(__MODULE__, %Grid{board_size: board_size}, name: __MODULE__)
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def join do
    GenServer.call(__MODULE__, :join)
  end

  ## Server Callbacks

  def handle_call(:get_state, _from, grid) do
    {:reply, {:ok, grid}, grid}
  end

  def handle_call(:join, _from, grid) do
    {:ok, board_id, new_grid} = Grid.add_board(grid)
    {:reply, {:ok, {grid.board_size, board_id}}, new_grid}
  end

  def handle_info(:tick, grid) do
    {:noreply, grid}
  end
end
