defmodule TestSuper.DynamicSupervisor do
  @moduledoc """
  Module providing server-side functions for `DynamicSupervisor`.
  """
  use DynamicSupervisor

  ## Constructor

  @doc """
  Constructor for `DynamicSupervisor`.
  """
  def start_link(opts \\ []) do
    DynamicSupervisor.start_link(__MODULE__, [], opts)
  end

  ## Callbacks

  @doc """
  `DynamicSupervisor` callback `init/1`.
  """
  def init([]) do
    opts = [
      name: TestSuper.DynamicSupervisor,
      strategy: :one_for_one
    ]

    DynamicSupervisor.init(opts)
  end

end
