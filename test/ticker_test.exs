defmodule GameOfLife.TickerTest do
  use ExUnit.Case, async: true
  doctest GameOfLife.Ticker

  setup do
    GameOfLife.EventManager.start_link
    {:ok, pid} = GameOfLife.Ticker.start_link(interval: 10)
    [ticker: pid]
  end

  describe "GameOfLife.Ticker.set_interval/1" do
    test "setting when stopped" do
      new_interval = 666
      :ok = GameOfLife.Ticker.set_interval(new_interval)
      {:ok, state} = GameOfLife.Ticker.get_state

      assert state.interval == new_interval
    end
  end

  test "stop the ticker" do
    {:ok, :started} = GameOfLife.Ticker.start_ticker
    {:ok, :stopped} = GameOfLife.Ticker.stop_ticker
  end

  test "the default interval", context do
    GenServer.stop(context.ticker)
    {:ok, _} = GameOfLife.Ticker.start_link
    {:ok, state} = GameOfLife.Ticker.get_state
    assert state.interval == 500
  end

  test "specifying interval via options", context do
    # Because it was already started we need to stop it
    GenServer.stop(context.ticker)
    {:ok, _} = GameOfLife.Ticker.start_link(interval: 42)
    {:ok, state} = GameOfLife.Ticker.get_state

    assert state.interval == 42
  end

end
