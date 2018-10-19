defmodule TestSuper.Server do
  @moduledoc """
  Module providing server-side functions for `GenServer`.
  """
  use GenServer

  ## Constructor

  @doc """
  Constructor for `GenServer`.
  """
  def start_link(opts \\ []) do
    case GenServer.start_link(__MODULE__, opts) do
      {:ok, pid} ->
        # register process name
        num = String.replace("#{inspect pid}", "#PID", "")
        Process.register(pid, Module.concat(__MODULE__, num))
        {:ok, pid}
      {:error, reason} -> {:error, reason}
    end
  end

  ## Callbacks

  @doc """
  Server callback `init/1`.
  """
  def init(_) do
    {:ok, Map.new}
  end

  @doc """
  Server callback `handle_call/3` for client `get/1`.
  """
  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  @doc """
  Server callback `handle_call/3` for client `get/2`.
  """
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.fetch!(state, key), state}
  end

  @doc """
  Server callback `handle_call/3` for client `keys/0`.
  """
  def handle_call({:keys}, _from, state) do
    {:reply, Map.keys(state), state}
  end

  @doc """
  Server callback `handle_cast/2` for client `put/3`.
  """
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

end
