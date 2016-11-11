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

  defstruct ticker_state: :stopped, interval: nil

  def start_link(opts \\ []) do
    init = %GameOfLife.Ticker{interval: (opts[:interval] || @default_interval_ms)}
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

  def handle_call(:stop, _from, %GameOfLife.Ticker{ticker_state: ticker_status} = state) do
    case ticker_status do
      :started ->
        new_state = %{state | ticker_state: :stopped}
        GenEvent.notify(GameOfLife.EventManager, {:ticker_update, new_state})
        {:reply, {:ok, :stopped}, new_state}
      :stopped ->
        {:reply, {:error, :already_stopped }, state}
    end
  end

  def handle_call(:start, _from, %GameOfLife.Ticker{ticker_state: ticker_status} = state) do
    case ticker_status do
      :started ->
        {:reply, {:error, :ticker_already_started}, state}
      :stopped ->
        new_state = %{state | ticker_state: :started}
        GenEvent.notify(GameOfLife.EventManager, {:ticker_update, new_state})
        {:reply, {:ok, :started}, new_state}
    end
  end

  def handle_call(:get_state, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:set_interval, new_interval}, _from, state) do
    new_state = %{state | interval: new_interval}
    GenEvent.notify(GameOfLife.EventManager, {:ticker_update, new_state})
    {:reply, :ok, new_state}
  end

end
