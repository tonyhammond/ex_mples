defmodule TestNeo4j.MixProject do
  use Mix.Project

  def project do
    [
      app: :test_neo4j,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.

  def application do
    [ 
      applications: [:bolt_sips],
      extra_applications: [:logger], mod: {Bolt.Sips.Application, [
          url: "localhost:7687",
          basic_auth: [username: "neo4j", password: "neo4jtest"]
        ]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bolt_sips, "~> 1.3"}
    ]
  end
end
