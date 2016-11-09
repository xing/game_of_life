defmodule GameOfLife do
  use Application
  alias GameOfLife.Board, as: Board

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(GameOfLife.BoardManager, [])
    ]

    if System.get_env("ROLE") == "master" do
      children = [worker(GameOfLife.EventManager, []) | children]
    end

    opts = [strategy: :one_for_one, name: GameOfLife.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @spec next_board_state(Board) :: Board
  def next_board_state(%Board{} = board) do
    Board.next_board_state(board)
  end
end
