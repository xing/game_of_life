defmodule GameOfLife.BoardSynchronizer do
  use GenEvent
  alias GameOfLife.Board

  @default_size 4
  defstruct board_pid: nil, board_id: nil, board_size: nil

  # Client

  def start_link(initial) do
    GenServer.start_link(__MODULE__, initial)
  end

  def neighbours(pid) do
    GenEvent.call(pid, __MODULE__, :neighbours)
  end

  def add_neighbour(pid, {board_pid, orientation}) do
    GenEvent.call(pid, __MODULE__, {:add_neighbour, {board_pid, orientation}})
  end

  # Server

  def init({board_pid, board_id, board_size}) do
    {:ok, %__MODULE__{board_pid: board_pid, board_id: board_id, board_size: board_size}}
  end

  def handle_event({:cells_update, cells}, state) do
    overlapping_cells = Enum.filter(cells, &overlapping_cell?(&1, state.board_id, state.board_size))
    # TODO: Board.update_foreign_area(state.board_pid, overlapping_cells)
    {:ok, state}
  end

  def overlapping_cell?({x, y}, {bid_x, bid_y}, {w, h}) do
    (x in (bid_x - 1)..(bid_x + w)) and (y in (bid_y - 1)..(bid_y + h))
  end
end
