defmodule TestSuper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def empty_static_start(_type, _args) do
    children = [
    ]

    opts = [
      name: TestSuper.Supervisor,
      strategy: :one_for_one
    ]
    Supervisor.start_link(children, opts)
  end

  def static_start(_type, _args) do
    children = [
      TestSuper.Server
    ]

    opts = [
      name: TestSuper.Supervisor,
      strategy: :one_for_one
    ]
    Supervisor.start_link(children, opts)
  end

  def dynamic_start(_type, _args) do

    opts = [
      name: TestSuper.Supervisor,
      strategy: :one_for_one
    ]
    DynamicSupervisor.start_link(opts)

  end

  def start(type, args), do: dynamic_start(type, args)
  # def start(type, args), do: static_start(type, args)
  # def start(type, args), do: empty_static_start(type, args)

end
