defmodule TestGraph.Application do
  @moduledoc false

  use Application


  def start(_type, _args) do
    import Supervisor.Spec

    TestGraph.RDF.SPARQL.Client.sparql_endpoint(:sparql_local)

    children = [
      worker(Bolt.Sips, [Application.get_env(:bolt_sips, Bolt)])
    ]

    opts = [strategy: :one_for_one, name: TestGraph.Supervisor]
    Supervisor.start_link(children, opts)

  end
end
