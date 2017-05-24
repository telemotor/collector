defmodule Clickhouser.InsertQueue do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_opts) do
    {:ok, []}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, []}
  end

  def handle_cast({:insert, data}, state) do
    {:noreply, state ++ [data]}
  end

  def insert(data) do
    GenServer.cast(__MODULE__, {:insert, data})
  end

  def get_queue() do
    GenServer.call(__MODULE__, :get)
  end
end
