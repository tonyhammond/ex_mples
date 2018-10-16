defmodule TestSuper.Server do
  use GenServer

  ## Constructor

  def start_link(_) do
    # start the process
    {:ok, pid} = GenServer.start_link(__MODULE__, [])

    # register process name
    num = String.replace("#{inspect pid}", "#PID", "")
    Process.register(pid, Module.concat(__MODULE__, num))

    # write status message to stdout
    IO.puts "TestSuper.Server is starting ... #{inspect pid}"

    {:ok, pid}
  end

  ## Callbacks

  def init(_) do
    {:ok, Map.new}
  end

  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.fetch!(state, key), state}
  end

  def handle_call({:list}, _from, state) do
    {:reply, Map.keys(state), state}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

end
