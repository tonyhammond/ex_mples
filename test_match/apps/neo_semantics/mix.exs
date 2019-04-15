defmodule NeoSemantics.MixProject do
  use Mix.Project

  def project do
    [
      app: :neo_semantics,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      # mod: {NeoSemantics.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bolt_sips, "~> 1.5"},
      {:hackney, "~> 1.15"}
      # {:tesla, "~> 1.2"}
    ]
  end
end
