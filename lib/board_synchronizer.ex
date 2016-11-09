defmodule GameOfLife.BoardSynchronizer do
  use GenEvent
  alias GameOfLife.Board

  defstruct board_pid: nil, board_id: nil, board_size: nil

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
