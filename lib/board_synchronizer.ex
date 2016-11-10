defmodule GameOfLife.BoardSynchronizer do
  use GenEvent
  alias GameOfLife.BoardServer

  @default_size 4
  defstruct board_pid: nil, board_id: nil, board_size: nil

  # Client

  def start_link(initial) do
    GenServer.start_link(__MODULE__, initial)
  end

  # Server

  def init({board_pid, board_id, board_size}) do
    {:ok, %__MODULE__{board_pid: board_pid, board_id: board_id, board_size: board_size}}
  end

  def handle_event({:board_update, neighbour_board}, state) do
    if neighbour_board.origin != state.board_id do
      case overlapping_area(
          board_area_with_margin(state.board_id, state.board_size),
          board_area(neighbour_board.origin, neighbour_board.size)) do
        {bottom_left, top_right} ->
          overlapping_cells = Enum.filter(neighbour_board.alive_cells, &overlapping_cell?(&1, state.board_id, state.board_size))
          BoardServer.update_foreign_area(state.board_pid, bottom_left, top_right, MapSet.new(overlapping_cells))
        nil -> true
      end
    end
    {:ok, state}
  end

  def handle_event(_, state) do
    {:ok, state}
  end

  def overlapping_cell?({x, y}, {bid_x, bid_y}, {w, h}) do
    (x in (bid_x - 1)..(bid_x + w)) and (y in (bid_y - 1)..(bid_y + h))
  end

  def board_area({x, y}, {w,h}), do: {{x, y}, {x + w - 1, y + h - 1}}

  def board_area_with_margin({x, y}, {w,h}), do: {{x - 1, y - 1}, {x + w, y + h}}

  def overlapping_area({{ax1, ay1}, {ax2, ay2}}, {{bx1, by1}, {bx2, by2}}) do
    area = {{max(ax1, bx1), max(ay1, by1)}, {min(ax2, bx2), min(ay2, by2)}}
    case valid_area?(area) do
       true -> area
       false -> nil
    end
  end

  def valid_area?({{x1, y1}, {x2, y2}}), do: x1 <= x2 and y1 <= y2
end
