defmodule TestSuper do
  @moduledoc """
  Top-level module used in "Robust compute for RDF queries" post.
  """

  ## 1. GenServers

  @doc """
  Contructor for new GenServer (with no supervision).
  """
  def new_server() do
    {:ok, pid} = TestSuper.Server.start_link(nil)
    pid
  end

  @doc """
  Contructor for new GenServer (with DynamicSupervisor).
  """
  def new_dyn_server() do
    {:ok, pid} = DynamicSupervisor.start_child(
        TestSuper.DynamicSupervisor, TestSuper.Server
      )
    pid
  end

  ## 2. Supervisors

  @doc """
  Contructor for new Supervisor/GenServer.
  """
  def new_super() do
    opts = [
      name: TestSuper.Supervisor,
      strategy: :one_for_one
    ]
    {:ok, pid} = TestSuper.Supervisor.start_link(opts)
    pid
  end

  @doc """
  Contructor for new DynamicSupervisor.
  """
  def new_dyn_super() do
    opts = [
      name: TestSuper.DynamicSupervisor,
      strategy: :one_for_one
    ]
    {:ok, pid} = TestSuper.DynamicSupervisor.start_link(opts)
    pid
  end

end
