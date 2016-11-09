defmodule GameOfLife.TickerTest do
  use ExUnit.Case, async: true
  doctest GameOfLife.Ticker

  setup do
    owner = self()
    {:ok, pid} = GameOfLife.Ticker.start_link(owner, interval: 10)
    [ticker: pid]
  end

  describe "GameOfLife.Ticker.set_interval/1" do
    test "setting when stopped" do
      new_interval = 666
      :ok = GameOfLife.Ticker.set_interval(new_interval)
      {:ok, state} = GameOfLife.Ticker.get_state

      assert state.interval == new_interval
    end

    test "setting when started" do
      {:ok, :started} = GameOfLife.Ticker.start_ticker

      assert {:error, :ticker_already_started} == GameOfLife.Ticker.set_interval(666)
    end
  end

  test "set internal ref after starting ticker" do
    {:ok, :started} = GameOfLife.Ticker.start_ticker
    {:ok, %GameOfLife.Ticker{interval_ref: interval_ref}} = GameOfLife.Ticker.get_state
    assert interval_ref != nil
  end

  test "receive tick message" do
    {:ok, :started} = GameOfLife.Ticker.start_ticker
    assert_receive :tick
  end

  test "stop the ticker" do
    {:ok, :started} = GameOfLife.Ticker.start_ticker
    assert_receive :tick

    {:ok, :stopped} = GameOfLife.Ticker.stop_ticker
    {:ok, %GameOfLife.Ticker{interval_ref: nil}} = GameOfLife.Ticker.get_state
    refute_received :tick
  end

  test "the default interval", context do
    GenServer.stop(context.ticker)
    {:ok, _} = GameOfLife.Ticker.start_link(self)
    {:ok, state} = GameOfLife.Ticker.get_state
    assert state.interval == 500
  end

  test "specifying interval via options", context do
    # Because it was already started we need to stop it
    GenServer.stop(context.ticker)
    {:ok, _} = GameOfLife.Ticker.start_link(self, interval: 42)
    {:ok, state} = GameOfLife.Ticker.get_state

    assert state.interval == 42
  end

end
