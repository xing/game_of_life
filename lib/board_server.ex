defmodule GameOfLife.BoardServer do
  alias GameOfLife.Board, as: Board
  use GenServer

  defstruct board: %Board{}

  def start_link(board_size, opts \\ []) do
    board = Keyword.get(opts, :board, %Board{})
    GenServer.start_link(__MODULE__, board)
  end

  def next_board_state(pid) do
    GenServer.call(pid, :next_board_state)
  end

  def update_foreign_area(pid, bottom_left, top_right, new_foreign_alive_cells) do
    GenServer.call(pid, {:update_foreign_area, bottom_left, top_right, new_foreign_alive_cells})
  end

  def current_board(pid) do
    GenServer.call(pid, :current_board)
  end

  def handle_call(:next_board_state, _from, board) do
    updated_board = Board.next_board_state(board)
    {:reply, {:ok, updated_board}, updated_board}
  end

  def handle_call({:update_foreign_area, bottom_left, top_right, new_foreign_alive_cells}, _from, board) do
    updated_board = Board.update_foreign_area(board, bottom_left, top_right, new_foreign_alive_cells)
    {:reply, {:ok}, updated_board}
  end

  def handle_call(:current_board, _from, board) do
    {:reply, {:ok, board}, board}
  end

end
