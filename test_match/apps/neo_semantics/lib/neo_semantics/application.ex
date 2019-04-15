defmodule NeoSemantics.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Bolt.Sips, [Application.get_env(:bolt_sips, Bolt)])
    ]

    opts = [strategy: :one_for_one, name: NeoSemantics.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
