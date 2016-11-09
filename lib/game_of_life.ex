defmodule GameOfLife do
  alias GameOfLife.Board, as: Board

  @spec next_board_state(Board) :: Board
  def next_board_state(%Board{} = board) do
    Board.next_board_state(board)
  end
end
