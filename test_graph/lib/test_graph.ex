defmodule TestGraph do
  @moduledoc """
  Top-level module used in
  "[Graph to graph with Elixir]()" post.
  """

  def help() do
    # __MODULE__.__info__(:functions)
    inspect(__MODULE__.__info__(:functions), limit: :infinity)
  end

  def help(module) do
    # module.__info__(:functions)
    inspect(module.__info__(:functions), limit: :infinity)
  end

  # shorthand forms

  def books(), do: TestGraph.LPG.books()
  def movies(), do: TestGraph.LPG.movies()

end
