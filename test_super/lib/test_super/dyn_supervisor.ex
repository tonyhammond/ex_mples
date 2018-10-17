defmodule TestSuper.DynamicSupervisor do
  use DynamicSupervisor

  ## Constructor

  @doc """
  Constructor for DynamicSupervisor.
  """
  def start_link(opts \\ []) do
    {:ok, pid} = DynamicSupervisor.start_link(__MODULE__, [], opts)
    IO.puts "TestSuper.DynamicSupervisor is starting ... #{inspect pid}"
    {:ok, pid}
  end

  ## Callbacks

  @doc """
  DynamicSupervisor callback `init/1`.
  """
  def init([]) do
    opts = [
      name: TestSuper.DynamicSupervisor,
      strategy: :one_for_one
    ]

    DynamicSupervisor.init(opts)
  end

end
