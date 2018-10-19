defmodule TestSuper.Supervisor do
  @moduledoc """
  Module providing server-side functions for `Supervisor`.
  """
  use Supervisor

  ## Constructor

  @doc """
  Constructor for `Supervisor`.
  """
  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, [], opts)
  end

  ## Callbacks

  @doc """
  `Supervisor` callback `init/1`.
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
