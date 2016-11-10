defmodule GameOfLife do
  use Application
  alias GameOfLife.Board, as: Board

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children =
      case System.get_env("ROLE") == "master" do
        true ->
          [ worker(GameOfLife.EventManager, []),
            worker(GameOfLife.GridManager, []),
            worker(GameOfLife.Ticker, [GameOfLife.GridManager])]
        false ->
          [ supervisor(GameOfLife.BoardManager, [], [id: :a]),
            supervisor(GameOfLife.BoardManager, [], [id: :b]) ]
      end

    opts = [strategy: :one_for_one, name: GameOfLife.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @spec next_board_state(Board) :: Board
  def next_board_state(%Board{} = board) do
    Board.next_board_state(board)
  end
end
