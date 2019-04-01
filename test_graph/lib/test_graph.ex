defmodule TestGraph do
  @moduledoc """
  Top-level module used in
  "[Graph to graph with Elixir]()" post.

  This post explores moving data between semantic and property graphs.

  Here's an example of querying a remote RDF service (DBpedia)
  using the `SPARQL.Client` module via a wrapped function `rquery!/0`
  and using the `neosemantics` stored procedures for transforming
  the semantic graph to a property graph and importing into a Neo4j
  instance.

  This example saves the RDF graph for staging. Not known yet how to deal
  with in-memory graphs using the `neosemantics` library.

  ## Examples

      iex> conn = Bolt.Sips.conn()
      iex> hello = (
      ...>    SPARQL.Client.rquery!
      ...>    |> RDF.Turtle.write_string!
      ...>    |> TestGraph.RDF.write_graph(file: "hello.ttl")
      ...>  )
      iex> conn |> NeoSemantics.import_rdf!(hello.uri, "Turtle")

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
