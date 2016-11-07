defmodule GameOfLife.Ticker do
  @moduledoc """
  This is Ticker Process

  ## Examples

      iex> {:ok, pid} = GameOfLife.Ticker.start_link(self())
      iex>  GameOfLife.Ticker.start_ticker(pid)
      {:ok, :started }
      iex>  GameOfLife.Ticker.start_ticker(pid)
      {:error, :already_started }
      iex>  GameOfLife.Ticker.stop_ticker(pid)
      {:ok, :stopped }
      iex>  GameOfLife.Ticker.stop_ticker(pid)
      {:error, :already_stopped }

  """
  use GenServer

  @default_interval_ms 500

  defstruct ticker_state: :stopped, owner_pid: nil, interval: nil, interval_ref: nil

  def start_link(owner, opts \\ []) do
    init = %GameOfLife.Ticker{owner_pid: owner, interval: (opts[:interval] || @default_interval_ms)}
    GenServer.start_link(__MODULE__, init)
  end

  def start_ticker(pid) do
    GenServer.call(pid, :start)
  end

  def stop_ticker(pid) do
    GenServer.call(pid, :stop)
  end

  def set_interval(pid, interval) do
    GenServer.call(pid, {:set_interval, interval})
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
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
    {:reply, {:error, :already_started}, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:set_interval, new_interval}, _from, %GameOfLife.Ticker{ticker_state: :stopped} = state) do
    new_state = %{state | interval: new_interval}
    {:reply, :ok, new_state}
  end

  def handle_call({:set_interval, _}, _from, state) do
    {:reply, {:error, :already_started}, state}
  end

end
