defmodule TestGraph do
  @moduledoc """
  Top-level module used in
  "[Graph to graph with Elixir]()" post.

  This post explores moving data between semantic and property graphs.

  See the [examples](https://github.com/tonyhammond/ex_mples/tree/master/test_graph/examples) directory for some example scripts.

  Here's an example of querying a remote RDF service (DBpedia)
  using the `SPARQL.Client` module via a wrapped function `rquery!/1`
  and using the stored procedures in the `NeoSemantics` module for transforming
  the semantic graph to a property graph and importing into a Neo4j
  instance.

  This example saves the RDF graph for staging. (Not known yet how to deal
  with in-memory graphs using the [`neosemantics`](https://github.com/jbarrasa/neosemantics) library.)

  ## Examples

      # 1. explicit form
      iex> elixir = (
      ...>   TestGraph.RDF.read_query("elixir.rq").data
      ...>   |> SPARQL.Client.rquery!
      ...>   |> RDF.Turtle.write_string!
      ...>   |> TestGraph.RDF.write_graph("elixir.ttl")
      ...> )
      iex> conn() |> NeoSemantics.import_rdf!(elixir.uri, "Turtle")

      # 2. implicit form
      iex> TestGraph.import_rdf_from_query("elixir.rq")

      # 3. implicit form (with alias)
      iex> import_rdf_from_query("elixir.rq")

  """
  import Bolt.Sips, only: [conn: 0]

  # alias TestGraph.RDF.SPARQL

  @test_graph_file "default.ttl"
  @test_query_file "default.rq"

  @doc """
  Imports into Neo4j an LPG graph transformed from an RDF graph.

  ## Examples

      iex> TestGraph.import_rdf_from_graph("elixir.ttl")
      [
        %{
          "extraInfo" => "",
          "namespaces" => %{
            "http://example.org/" => "ns0",
            "http://purl.org/dc/elements/1.1/" => "dc",
            "http://purl.org/dc/terms/" => "dct",
            "http://schema.org/" => "sch",
            "http://www.w3.org/1999/02/22-rdf-syntax-ns#" => "rdf",
            "http://www.w3.org/2000/01/rdf-schema#" => "rdfs",
            "http://www.w3.org/2002/07/owl#" => "owl",
            "http://www.w3.org/2004/02/skos/core#" => "skos"
          },
          "terminationStatus" => "OK",
          "triplesLoaded" => 4
        }
      ]

  """
  def import_rdf_from_graph(graph_file \\ @test_graph_file) do
    graph = TestGraph.RDF.read_graph(graph_file)
    conn() |> NeoSemantics.import_rdf!(graph.uri, "Turtle")
  end

  @doc """
  Imports into Neo4j an LPG graph transformed from an RDF graph which was
  queried from a remote datastore using a SPARQL endpoint.

  ## Examples

      iex> TestGraph.import_rdf_from_query("elixir.rq")
      [
        %{
          "extraInfo" => "",
          "namespaces" => %{
            "http://example.org/" => "ns0",
            "http://purl.org/dc/elements/1.1/" => "dc",
            "http://purl.org/dc/terms/" => "dct",
            "http://schema.org/" => "sch",
            "http://www.w3.org/1999/02/22-rdf-syntax-ns#" => "rdf",
            "http://www.w3.org/2000/01/rdf-schema#" => "rdfs",
            "http://www.w3.org/2002/07/owl#" => "owl",
            "http://www.w3.org/2004/02/skos/core#" => "skos"
          },
          "terminationStatus" => "OK",
          "triplesLoaded" => 4
        }
      ]

  """
  def import_rdf_from_query(query_file \\ @test_query_file) do
    graph_file = Path.basename(query_file, ".rq") <> ".ttl"
    graph = (
      TestGraph.RDF.read_query(query_file).data
      |> TestGraph.RDF.SPARQL.Client.rquery!
      |> RDF.Turtle.write_string!
      |> TestGraph.RDF.write_graph(graph_file)
    )
    conn() |> NeoSemantics.import_rdf!(graph.uri, "Turtle")
  end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is centered on a node identified by `node_id`.

  This returns the full context unless an optional boolean arg `exclude_context`
  is passed as `true` which will exclude context if present.

  ## Examples

      iex> TestGraph.export_rdf_by_id(1783)
      %TestGraph.Graph{
        data: "@prefix neovoc: <neo4j://defaultvocabulary#> .\\n@prefix neoind: <neo4j://indiv#> .\\n\\n\\nneoind:1783 a neovoc:Resource;\\n  neovoc:ns0__creator neoind:1785;\\n  neovoc:ns0__homepage neoind:1784;\\n  neovoc:ns0__license neoind:1786;\\n  neovoc:ns0__name \"Elixir\";\\n  neovoc:uri \"http://example.org/Elixir\" .\\n",
        file: "1783.ttl",
        path: "/Users/tony/Projects/github/tonyhammond/ex_mples/test_graph/_build/dev/lib/test_graph/priv/rdf/graphs/1783.ttl",
        type: :rdf,
        uri: "file:///Users/tony/Projects/github/tonyhammond/ex_mples/test_graph/_build/dev/lib/test_graph/priv/rdf/graphs/1783.ttl"
      }

      iex> TestGraph.export_rdf_by_id(1783).data
      "@prefix neovoc: <neo4j://defaultvocabulary#> .\\n@prefix neoind: <neo4j://indiv#> .\\n\\n\\nneoind:1783 a neovoc:Resource;\\n  neovoc:ns0__creator neoind:1785;\\n  neovoc:ns0__homepage neoind:1784;\\n  neovoc:ns0__license neoind:1786;\\n  neovoc:ns0__name \"Elixir\";\\n  neovoc:uri \"http://example.org/Elixir\" .\\n"

  """
  def export_rdf_by_id(node_id, exclude_context \\ false) do
    id = Integer.to_string(node_id)
    data = NeoSemantics.Extension.node_by_id(node_id, exclude_context)
    TestGraph.RDF.write_graph(data, id <> ".ttl")
  end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is centered on a node identified by `node_uri`.

  This returns the full context unless an optional boolean arg `exclude_context`
  is passed as `true` which will exclude context if present.

  ## Examples

      iex> TestGraph.export_rdf_by_uri("http://example.org/Elixir")
      %TestGraph.Graph{
        data: "@prefix neovoc: <neo4j://vocabulary#> .\\n\\n\\n<http://example.org/Elixir> <http://example.org/creator> <http://dbpedia.org/resource/José_Valim>;\\n  <http://example.org/homepage> <http://elixir-lang.org>;\\n  <http://example.org/license> <http://dbpedia.org/resource/Apache_License>;\\n  <http://example.org/name> \"Elixir\" .\\n",
        file: "http___example.org_Elixir.ttl",
        path: ... <> "/test_graph/priv/rdf/graphs/http___example.org_Elixir.ttl",
        type: :rdf,
        uri: "file:\/\/\/" <> ... <> "/test_graph/priv/rdf/graphs/http___example.org_Elixir.ttl"
      }

      iex> TestGraph.export_rdf_by_uri("http://example.org/Elixir").data
      "@prefix neovoc: <neo4j://vocabulary#> .\\n\\n\\n<http://example.org/Elixir> <http://example.org/creator> <http://dbpedia.org/resource/José_Valim>;\\n  <http://example.org/homepage> <http://elixir-lang.org>;\\n  <http://example.org/license> <http://dbpedia.org/resource/Apache_License>;\\n  <http://example.org/name> \"Elixir\" .\\n"

  """
  def export_rdf_by_uri(node_uri, exclude_context \\ false) do
    uri = URI.encode(node_uri)
    uri_safe  = String.replace(uri, ~r/[\/\?\:\@]/, "_")
    data = NeoSemantics.Extension.node_by_uri(node_uri, exclude_context)
    TestGraph.RDF.write_graph(data, uri_safe <> ".ttl")
  end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is defined by the `cypher` query.

  ## Examples

      iex> cypher = TestGraph.LPG.read_query("node1.cypher").data
      "match (n) return n limit 1\\n"
      iex> cypher |> TestGraph.export_rdf_by_query
  """
  def export_rdf_by_query(cypher, graph_file) do
    data = NeoSemantics.Extension.cypher(cypher)
    TestGraph.RDF.write_graph(data, graph_file)
  end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is defined by the `cypher` query.

  ## Examples

      iex> cypher =
      "match (n:Resource {uri:'http://dataset/indiv#153'}) return n\\n"
      iex> cypher |> TestGraph.export_rdf_by_query_on_rdf
  """
  def export_rdf_by_query_on_rdf(cypher, graph_file) do
    data = NeoSemantics.Extension.cypher_on_rdf(cypher)
    TestGraph.RDF.write_graph(data, graph_file)
  end

  # TestGraph.LPG delegates
  @doc "Delegates to TestGraph.LPG.books/0"
  defdelegate lpg_books(), to: TestGraph.LPG, as: :books
  @doc "Delegates to TestGraph.LPG.movies/0"
  defdelegate lpg_movies(), to: TestGraph.LPG, as: :movies

  @doc "Delegates to TestGraph.LPG.list_graphs/0"
  defdelegate list_lpg_graphs(), to: TestGraph.LPG, as: :list_graphs
  @doc "Delegates to TestGraph.LPG.list_queries/0"
  defdelegate list_lpg_queries(), to: TestGraph.LPG, as: :list_queries

  @doc "Delegates to TestGraph.LPG.read_graph/0"
  defdelegate read_lpg_graph(), to: TestGraph.LPG, as: :read_graph
  @doc "Delegates to TestGraph.LPG.read_graph/1"
  defdelegate read_lpg_graph(arg), to: TestGraph.LPG, as: :read_graph
  @doc "Delegates to TestGraph.LPG.read_query/0"
  defdelegate read_lpg_query(), to: TestGraph.LPG, as: :read_query
  @doc "Delegates to TestGraph.LPG.read_query/1"
  defdelegate read_lpg_query(arg), to: TestGraph.LPG, as: :read_query

  @doc "Delegates to TestGraph.LPG.write_graph/1"
  defdelegate write_lpg_graph(arg), to: TestGraph.LPG, as: :write_graph
  @doc "Delegates to TestGraph.LPG.write_graph/2"
  defdelegate write_lpg_graph(arg1, arg2), to: TestGraph.LPG, as: :write_graph
  @doc "Delegates to TestGraph.LPG.write_query/1"
  defdelegate write_lpg_query(arg), to: TestGraph.LPG, as: :write_query
  @doc "Delegates to TestGraph.LPG.write_query/2"
  defdelegate write_lpg_query(arg1, arg2), to: TestGraph.LPG, as: :write_query

  # TestGraph.RDF delegates
  @doc "Delegates to TestGraph.RDF.list_graphs/0"
  defdelegate list_rdf_graphs(), to: TestGraph.RDF, as: :list_graphs
  @doc "Delegates to TestGraph.RDF.list_queries/0"
  defdelegate list_rdf_queries(), to: TestGraph.RDF, as: :list_queries

  @doc "Delegates to TestGraph.RDF.read_graph/0"
  defdelegate read_rdf_graph(), to: TestGraph.RDF, as: :read_graph
  @doc "Delegates to TestGraph.RDF.read_graph/1"
  defdelegate read_rdf_graph(arg), to: TestGraph.RDF, as: :read_graph
  @doc "Delegates to TestGraph.RDF.read_query/0"
  defdelegate read_rdf_query(), to: TestGraph.RDF, as: :read_query
  @doc "Delegates to TestGraph.RDF.read_query/1"
  defdelegate read_rdf_query(arg), to: TestGraph.RDF, as: :read_query

  @doc "Delegates to TestGraph.RDF.write_graph/1"
  defdelegate write_rdf_graph(arg), to: TestGraph.RDF, as: :write_graph
  @doc "Delegates to TestGraph.RDF.write_graph/2"
  defdelegate write_rdf_graph(arg1, arg2), to: TestGraph.RDF, as: :write_graph
  @doc "Delegates to TestGraph.RDF.write_query/1"
  defdelegate write_rdf_query(arg), to: TestGraph.RDF, as: :write_query
  @doc "Delegates to TestGraph.RDF.write_query/2"
  defdelegate write_rdf_query(arg1, arg2), to: TestGraph.RDF, as: :write_query

  # TestGraph.LPG.Cypher.Client delegates
  @doc "Delegates to TestGraph.LPG.Cypher.Client.rquery/0"
  defdelegate cypher(), to: TestGraph.LPG.Cypher.Client, as: :rquery
  @doc "Delegates to TestGraph.LPG.Cypher.Client.rquery/1"
  defdelegate cypher(arg), to: TestGraph.LPG.Cypher.Client, as: :rquery
  @doc "Delegates to TestGraph.LPG.Cypher.Client.rquery/0"
  defdelegate cypher!(), to: TestGraph.LPG.Cypher.Client, as: :rquery!
  @doc "Delegates to TestGraph.LPG.Cypher.Client.rquery/1"
  defdelegate cypher!(arg), to: TestGraph.LPG.Cypher.Client, as: :rquery!

  @doc "Delegates to TestGraph.LPG.Cypher.Client.clear/0"
  defdelegate cypher_clear(), to: TestGraph.LPG.Cypher.Client, as: :clear
  @doc "Delegates to TestGraph.LPG.Cypher.Client.dump/1"
  defdelegate cypher_dump(arg), to: TestGraph.LPG.Cypher.Client, as: :dump
  @doc "Delegates to TestGraph.LPG.Cypher.Client.dump/2"
  defdelegate cypher_dump(arg1, arg2), to: TestGraph.LPG.Cypher.Client, as: :dump
  @doc "Delegates to TestGraph.LPG.Cypher.Client.init/0"
  defdelegate cypher_init(), to: TestGraph.LPG.Cypher.Client, as: :init
  @doc "Delegates to TestGraph.LPG.Cypher.Client.reset/0"
  defdelegate cypher_reset(), to: TestGraph.LPG.Cypher.Client, as: :reset
  @doc "Delegates to TestGraph.LPG.Cypher.Client.test/0"
  defdelegate cypher_test(), to: TestGraph.LPG.Cypher.Client, as: :test

  # TestGraph.RDF.SPARQL  .Client delegates
  @doc "Delegates to TestGraph.RDF.SPARQL.Client.rquery/0"
  defdelegate sparql(), to: TestGraph.RDF.SPARQL.Client, as: :rquery
  @doc "Delegates to TestGraph.RDF.SPARQL.Client.rquery/1"
  defdelegate sparql(arg), to: TestGraph.RDF.SPARQL.Client, as: :rquery
  @doc "Delegates to TestGraph.RDF.SPARQL.Client.rquery/2"
  defdelegate sparql(arg1, arg2), to: TestGraph.RDF.SPARQL.Client, as: :rquery
  @doc "Delegates to TestGraph.RDF.SPARQL.Client.rquery/0"
  defdelegate sparql!(), to: TestGraph.RDF.SPARQL.Client, as: :rquery!
  @doc "Delegates to TestGraph.RDF.SPARQL.Client.rquery/1"
  defdelegate sparql!(arg), to: TestGraph.RDF.SPARQL.Client, as: :rquery!
  @doc "Delegates to TestGraph.RDF.SPARQL.Client.rquery/2"
  defdelegate sparql!(arg1, arg2), to: TestGraph.RDF.SPARQL.Client, as: :rquery!

  @doc "Delegates to TestGraph.RDF.SPARQL.Client.sparql_endpoint/0"
  defdelegate sparql_endpoint(), to: TestGraph.RDF.SPARQL.Client, as: :sparql_endpoint
  @doc "Delegates to TestGraph.RDF.SPARQL.Client.sparql_endpoint/1"
  defdelegate sparql_endpoint(arg), to: TestGraph.RDF.SPARQL.Client, as: :sparql_endpoint
  @doc "Delegates to TestGraph.RDF.SPARQL.Client.sparql_query/0"
  defdelegate sparql_query(), to: TestGraph.RDF.SPARQL.Client, as: :sparql_query
  @doc "Delegates to TestGraph.RDF.SPARQL.Client.sparql_query/1"
  defdelegate sparql_query(arg), to: TestGraph.RDF.SPARQL.Client, as: :sparql_query

  @doc "Delegates to TestGraph.RDF.SPARQL.Client.sparql_services/0"
  defdelegate list_sparql_services(), to: TestGraph.RDF.SPARQL.Client, as: :sparql_services

  @doc "Delegates to TestGraph.RDF.SPARQL.Client.dbpedia_sparql_endpoint/0"
  defdelegate dbpedia_sparql_endpoint(), to: TestGraph.RDF.SPARQL.Client, as: :dbpedia_sparql_endpoint
  @doc "Delegates to TestGraph.RDF.SPARQL.Client.local_sparql_endpoint/0"
  defdelegate local_sparql_endpoint(), to: TestGraph.RDF.SPARQL.Client, as: :local_sparql_endpoint
  @doc "Delegates to TestGraph.RDF.SPARQL.Client.wikidata_sparql_endpoint/0"
  defdelegate wikidata_sparql_endpoint(), to: TestGraph.RDF.SPARQL.Client, as: :wikidata_sparql_endpoint

end
