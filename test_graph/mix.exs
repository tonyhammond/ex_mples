defmodule TestGraph.MixProject do
  use Mix.Project

  def project do
    [
      app: :test_graph,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TestGraph.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},

      # property graphs
      {:bolt_sips, "~> 1.5"},

      # rdf graphs
      {:sparql_client, "~> 0.2"},
      {:hackney, "~> 1.15"}
    ]
  end
end
