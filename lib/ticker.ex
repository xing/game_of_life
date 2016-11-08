defmodule GameOfLife.Ticker do
  @moduledoc """
  This is Ticker Process

  ## Examples

      GameOfLife.Ticker.start_link(self())
      iex>  GameOfLife.Ticker.start_ticker
      {:ok, :started }
      iex>  GameOfLife.Ticker.start_ticker
      {:error, :ticker_already_started }
      iex>  GameOfLife.Ticker.stop_ticker
      {:ok, :stopped }
      iex>  GameOfLife.Ticker.stop_ticker
      {:error, :already_stopped }

  """
  use GenServer

  @default_interval_ms 500

  defstruct ticker_state: :stopped, owner_pid: nil, interval: nil, interval_ref: nil

  def start_link(owner, opts \\ []) do
    init = %GameOfLife.Ticker{owner_pid: owner, interval: (opts[:interval] || @default_interval_ms)}
    GenServer.start_link(__MODULE__, init, [name: __MODULE__])
  end

  def start_ticker do
    GenServer.call(__MODULE__, :start)
  end

  def stop_ticker do
    GenServer.call(__MODULE__, :stop)
  end

  def set_interval(interval) do
    GenServer.call(__MODULE__, {:set_interval, interval})
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def handle_call(:stop, _from, %GameOfLife.Ticker{ticker_state: :started} = state) do
    {:ok, _} = :timer.cancel(state.interval_ref)
    new_state = %{state | ticker_state: :stopped, interval_ref: nil}
    {:reply, {:ok, :stopped}, new_state}
  end

  def handle_call(:stop, _from, %GameOfLife.Ticker{ticker_state: :stopped} = state) do
    {:reply, {:error, :already_stopped }, state}
  end

  def handle_call(:start, _from, %GameOfLife.Ticker{ticker_state: :stopped} = state) do
    {:ok, interval_ref} = :timer.send_interval(state.interval, state.owner_pid, :tick)
    new_state = %{state | ticker_state: :started, interval_ref: interval_ref}
    {:reply, {:ok, :started}, new_state}
  end

  def handle_call(:start, _from, %GameOfLife.Ticker{ticker_state: :started} = state) do
    {:reply, {:error, :ticker_already_started}, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:set_interval, new_interval}, _from, %GameOfLife.Ticker{ticker_state: :stopped} = state) do
    new_state = %{state | interval: new_interval}
    {:reply, :ok, new_state}
  end

  def handle_call({:set_interval, _}, _from, state) do
    {:reply, {:error, :ticker_already_started}, state}
  end

end
