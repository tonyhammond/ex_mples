defmodule TestNeo4j.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Bolt.Sips, [Application.get_env(:bolt_sips, Bolt)])
    ]

    opts = [strategy: :one_for_one, name: TestNeo4j.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
