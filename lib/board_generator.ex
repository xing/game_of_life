defmodule GameOfLife.BoardGenerator do

  def new(board \\  %GameOfLife.Board{}) do
    spawn fn -> loop(board) end
  end

  def next_board_state(pid) do
    send(pid, {:next_board_state, self()})
    receive do x -> x end
  end

  defp loop(board) do
    receive do
      {:next_board_state, from} ->
        next_board_state = GameOfLife.Board.next_board_state(board)
        send(from, next_board_state)
        loop(next_board_state)
    end
  end

end
