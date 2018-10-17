defmodule TestSuper.Application do
  @moduledoc """
  Module providing the Application start function.
  """

  use Application

  ## Note this is really for dev purposes - should remove.

  # @doc false
  # defp _empty_static_start(_type, _args) do
  #   children = [
  #   ]
  #   opts = [
  #     name: TestSuper.Supervisor,
  #     strategy: :one_for_one
  #   ]
  #
  #   # now start up the Supervisor
  #   Supervisor.start_link(children, opts)
  # end
  #
  # @doc false
  # defp _static_start(_type, _args) do
  #   children = [
  #     TestSuper.Server
  #   ]
  #   opts = [
  #     name: TestSuper.Supervisor,
  #     strategy: :one_for_one
  #   ]
  #
  #   # now start up the Supervisor
  #   Supervisor.start_link(children, opts)
  # end

  @doc false
  defp _dynamic_start(_type, _args) do
    opts = [
      name: TestSuper.DynamicSupervisor,
      strategy: :one_for_one
    ]

    # now start up the DynamicSupervisor
    DynamicSupervisor.start_link(opts)
  end

  @doc false
  def start(type, args), do: _dynamic_start(type, args)
  # def start(type, args), do: _static_start(type, args)
  # def start(type, args), do: _empty_static_start(type, args)

end
