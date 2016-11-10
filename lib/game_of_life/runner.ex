defmodule GameOfLife.Runner do
  alias GameOfLife.{GridManager, Grid, Ticker, BoardServer}

  def run do
     do_run
  end

  def do_run do
    {:ok, %Grid{board_server_pids: pids}} = GridManager.get_state

    Map.values(pids)
    |> Enum.map(fn pid ->
        {:ok, _ } = BoardServer.next_board_state(pid)
      end)

    {:ok, %Ticker{interval: interval}} = Ticker.get_state
    :timer.sleep(interval)
    do_run
  end
end
