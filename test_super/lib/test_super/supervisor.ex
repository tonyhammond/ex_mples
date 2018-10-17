defmodule TestSuper.Supervisor do
  use Supervisor

  ## Constructor

  @doc """
  Constructor for Supervisor.
  """
  def start_link(opts \\ []) do
    {:ok, pid} = Supervisor.start_link(__MODULE__, [], opts)
    IO.puts "TestSuper.Supervisor is starting ... #{inspect pid}"
    {:ok, pid}
  end

  ## Callbacks

  @doc """
  Supervisor callback `init/1`.
  """
  def init([]) do
    children = [
      TestSuper.Server
    ]
    opts = [
      name: TestSuper.Supervisor,
      strategy: :one_for_one
    ]

    Supervisor.init(children, opts)
  end

end
