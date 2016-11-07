defmodule GameOfLife.TickerTest do
  use ExUnit.Case, async: true
  doctest GameOfLife.Ticker

  setup do
    owner = self()
    {:ok, pid} = GameOfLife.Ticker.start_link(owner)
    [ticker: pid]
  end

  describe "GameOfLife.Ticker.set_interval/1" do
    test "setting when stopped", context do
      new_interval = 666
      :ok = GameOfLife.Ticker.set_interval(context.ticker, new_interval)
      {:ok, state} = GameOfLife.Ticker.get_state(context.ticker)

      assert state.interval == new_interval
    end

    test "setting when started", context do
      {:ok, :started} = GameOfLife.Ticker.start_ticker(context.ticker)

      assert {:error, :already_started} == GameOfLife.Ticker.set_interval(context.ticker, 666)
    end
  end

  test "set internal ref after starting ticker", context do
    {:ok, :started} = GameOfLife.Ticker.start_ticker(context.ticker)
    {:ok, %GameOfLife.Ticker{interval_ref: interval_ref}} = GameOfLife.Ticker.get_state(context.ticker)
    assert interval_ref != nil
  end

  test "receive tick message", context do
    {:ok, :started} = GameOfLife.Ticker.start_ticker(context.ticker)
    assert_receive :tick, 501
  end

  test "stop the ticker", context do
    {:ok, :started} = GameOfLife.Ticker.start_ticker(context.ticker)
    assert_receive :tick, 501

    {:ok, :stopped} = GameOfLife.Ticker.stop_ticker(context.ticker)
    {:ok, %GameOfLife.Ticker{interval_ref: nil}} = GameOfLife.Ticker.get_state(context.ticker)
    refute_received :tick, 501
  end

  test "the default interval", context do
    {:ok, state} = GameOfLife.Ticker.get_state(context.ticker)
    assert state.interval == 500
  end

  test "specifying interval via options" do
    {:ok, pid} = GameOfLife.Ticker.start_link(self, interval: 42)
    {:ok, state} = GameOfLife.Ticker.get_state(pid)

    assert state.interval == 42
  end

end
