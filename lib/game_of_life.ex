defmodule GameOfLife do
  @spec next_board_state(Board) :: Board
  def next_board_state(%GameOfLife.Board{} = board) do
    GameOfLife.Board.next_board_state(board)
  end
end
