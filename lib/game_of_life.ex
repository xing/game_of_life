defmodule GameOfLife do
  use Application
  alias GameOfLife.Board, as: Board

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(GameOfLife.BoardManager, [])
    ]

    if Application.get_env(:game_of_life, :role) == :master do
      children = List.insert_at(children, 0, worker(GameOfLife.EventManager, []))
    end

    opts = [strategy: :one_for_one, name: GameOfLife.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @spec next_board_state(Board) :: Board
  def next_board_state(%Board{} = board) do
    Board.next_board_state(board)
  end
end
