defmodule GameOfLife.Runner do
  alias GameOfLife.{GridManager, Grid, Ticker, BoardServer}

  def run do
    {:ok, %Ticker{interval: interval, ticker_state: ticker_state}} = Ticker.get_state
    case ticker_state do
      :started ->
        run_next_turn()
        :timer.sleep(interval)
      :stopped ->
        :timer.sleep(100) # Just wait and check the state again after a while
    end
    run
  end

  def run_next_turn do
    {:ok, %Grid{board_server_pids: pids}} = GridManager.get_state

    Map.values(pids)
    |> Enum.map(fn pid ->
        {:ok, _ } = BoardServer.next_board_state(pid)
      end)

    Map.values(pids)
    |> Enum.map(fn pid ->
        {:ok, board } = BoardServer.current_board(pid)
        GenEvent.notify(GameOfLife.EventManager, {:board_update, board})
      end)
  end
end
