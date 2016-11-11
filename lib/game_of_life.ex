defmodule GameOfLife do
  use Application
  alias GameOfLife.Board, as: Board

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    boards = (System.get_env("BOARDS") || "2") |> String.to_integer

    grid_workers =
          [ worker(GameOfLife.EventManager, []),
            worker(GameOfLife.GridManager, []),
            worker(GameOfLife.Ticker, [])]

    board_managers = Enum.map(0..(boards - 1), fn n ->
        supervisor(GameOfLife.BoardManager, [], [id: n])
      end)

    children = grid_workers ++ board_managers
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
