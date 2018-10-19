defmodule TestSuper.Application do
  @moduledoc """
  Module providing the `Application` start function.
  """
  use Application

  @doc false
  defp _static_start(_type, _args) do
    children = [
      TestSuper.Server
    ]
    opts = [
      name: TestSuper.Supervisor,
      strategy: :one_for_one
    ]

    # now start up the Supervisor
    Supervisor.start_link(children, opts)
  end

  @doc false
  defp _dynamic_start(_type, _args) do
    opts = [
      name: TestSuper.DynamicSupervisor,
      strategy: :one_for_one
    ]

    # now start up the DynamicSupervisor
    DynamicSupervisor.start_link(opts)
  end

  @doc """
  Application `start/2` function calls`_start/3` with boolean `flag`.

  The boolean `flag` arg on the `_start/3` call selects a dynamic supervision
  tree on `true`, and a static supervision tree on `false`. Initial setting
  is `false`, i.e. selects for a static supervision tree.
  """
  def start(type, args) do
    _start(type, args, true)
  end

  @doc false
  defp _start(type, args, flag) do
    case flag do
      false -> _static_start(type, args)
      true -> _dynamic_start(type, args)
    end
  end

end
