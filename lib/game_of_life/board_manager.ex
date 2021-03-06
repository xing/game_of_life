defmodule GameOfLife.BoardManager do
  alias GameOfLife.BoardSynchronizer
  alias GameOfLife.BoardServer
  use Supervisor

  def start_link do
    {:ok, response} = GameOfLife.GridManager.request_join
    {:ok, supervisor_pid} = Supervisor.start_link(__MODULE__, [])
    start_children(supervisor_pid, response)
    {:ok, supervisor_pid}
  end

  def init([]) do
    supervise([], strategy: :one_for_one)
  end

  def start_children(supervisor_pid, {board_size, board_id}) do
    pattern = String.to_atom(System.get_env("PATTERN") || "random") 
    {:ok, board_server_pid} = Supervisor.start_child(supervisor_pid, worker(BoardServer, [board_id, board_size, [pattern: pattern]]))
    :ok = GenEvent.add_handler(GameOfLife.EventManager, {BoardSynchronizer, board_id}, {board_server_pid, board_id, board_size})
    GameOfLife.GridManager.confirm_join(board_server_pid, board_id)
  end
end
