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
      ...>   SPARQL.Client.rquery!
      ...>   |> RDF.Turtle.write_string!
      ...>   |> TestGraph.RDF.write_graph("hello.ttl")
      ...> )
      iex> conn |> NeoSemantics.import_rdf!(hello.uri, "Turtle")

      iex> elixir = (
      ...>   TestGraph.RDF.read_query("elixir.rq")
      ...>   |> SPARQL.Client.rquery!
      ...>   |> RDF.Turtle.write_string!
      ...>   |> TestGraph.RDF.write_graph("elixir.ttl")
      ...> )
      iex> conn |> NeoSemantics.import_rdf!(elixir.uri, "Turtle")

  """

  alias TestGraph.RDF.SPARQL

  @doc """
  Imports into Neo4j an LPG graph transformed from an RDF graph.

  ## Examples

      iex> TestGraph.import_rdf_from_graph("elixir.ttl")

  """
  def import_rdf_from_graph(graph_file) do
    # conn = TestGraph.LPG.init()
    conn = Bolt.Sips.conn()
    ttl = graph_file
    graph = (
      TestGraph.RDF.read_graph(ttl)
    )
    conn |> NeoSemantics.import_rdf!(graph.uri, "Turtle")
  end

  @doc """
  Imports into Neo4j an LPG graph transformed from an RDF graph which was
  queried from a remote datastore using a SPARQL endpoint.

  ## Examples

      iex> TestGraph.import_rdf_from_query("elixir.rq")

  """
  def import_rdf_from_query(query_file) do
    # conn = TestGraph.LPG.init()
    conn = Bolt.Sips.conn()
    ttl = Path.basename(query_file, ".rq") <> ".ttl"
    graph = (
      TestGraph.RDF.read_query(query_file)
      |> SPARQL.Client.rquery!
      |> RDF.Turtle.write_string!
      |> TestGraph.RDF.write_graph(ttl)
    )
    conn |> NeoSemantics.import_rdf!(graph.uri, "Turtle")
  end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is centered on a node identified by `node_id`.

  This returns the full context unless an optional boolean arg `exclude_context`
  is passed as `true` which will exclude context if present.

  ## Examples

      iex> TestGraph.export_rdf_by_id(1834)

  """
  def export_rdf_by_id(node_id, exclude_context \\ false) do
    id = Integer.to_string(node_id)
    # method = :get
    base = "http://neo4j:neo4jtest@localhost:7474"
    path = "/rdf/describe/id"
    query =
      case exclude_context do
        true -> "?nodeid=" <> id <> "&excludeContext"
        false -> "?nodeid=" <> id
      end
    {:ok, env} = Tesla.get(base <> path <> query)
    TestGraph.RDF.write_graph(env.body, id <> ".ttl")
  end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is centered on a node identified by `node_uri`.

  This returns the full context unless an optional boolean arg `exclude_context`
  is passed as `true` which will exclude context if present.

  ## Examples

      iex> TestGraph.export_rdf_by_uri("http://example.org/Elixir")

  """
  def export_rdf_by_uri(node_uri, exclude_context \\ false) do
    uri = URI.encode(node_uri)
    uri_safe  = String.replace(uri, ~r/[\/\?\:\@]/, "_")
    # method = :get
    base = "http://neo4j:neo4jtest@localhost:7474"
    path = "/rdf/describe/uri"
    query =
      case exclude_context do
        true -> "?nodeuri=" <> uri <> "&excludeContext"
        false -> "?nodeuri=" <> uri
      end
    {:ok, env} = Tesla.get(base <> path <> query)
    TestGraph.RDF.write_graph(env.body, uri_safe <> ".ttl")
  end

end
