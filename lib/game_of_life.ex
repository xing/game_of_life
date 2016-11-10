defmodule GameOfLife do
  use Application
  alias GameOfLife.Board, as: Board

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children =
          [ worker(GameOfLife.EventManager, []),
            worker(GameOfLife.GridManager, []),
            worker(GameOfLife.Ticker, [GameOfLife.GridManager]),
            supervisor(GameOfLife.BoardManager, [], [id: :a]),
            supervisor(GameOfLife.BoardManager, [], [id: :b]) ]

    opts = [strategy: :one_for_one, name: GameOfLife.Supervisor]
    start_status = Supervisor.start_link(children, opts)
    spawn(fn -> GameOfLife.Runner.run end)
    start_status
  end

  @spec next_board_state(Board) :: Board
  def next_board_state(%Board{} = board) do
    Board.next_board_state(board)
  end
end
