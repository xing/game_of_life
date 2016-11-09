defmodule GameOfLife.BoardServer do
  alias GameOfLife.Board, as: Board
  use GenServer

  defstruct board: %Board{}

  def start_link(owner, opts \\ []) do
    board = Keyword.get(opts, :board, %Board{})
    GenServer.start_link(__MODULE__, board)
  end

  def next_board_state(pid) do
    GenServer.call(pid, :next_board_state)
  end

  def handle_call(:next_board_state, _from, board) do
    board2 = Board.next_board_state(board)
    {:reply, {:ok, board2}, board2}
  end

end
