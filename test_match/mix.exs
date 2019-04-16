defmodule TestMatch.MixProject do
  use Mix.Project

  def project do
    [
      app: :test_match,
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
      mod: {TestMatch.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},

      # property graphs
      {:bolt_sips, "~> 1.5"},
      {:dep_from_git, git: "https://github.com/tonyhammond/neo_semantics.git", tag: "0.1.2", app: false},

      # rdf graphs
      {:sparql_client, "~> 0.2"},
      {:hackney, "~> 1.15"}
    ]
  end
end
