defmodule TestGraph do
  @moduledoc """
  Top-level module used in
  "[Graph to graph with Elixir]()" post.

  This post explores moving data between semantic and property graphs.

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

  alias TestGraph.RDF.SPARQL

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
      |> SPARQL.Client.rquery!
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
    data = NeoSemantics.Extension.cypher_on_lpg(cypher)
    TestGraph.RDF.write_graph(data, graph_file)
  end

end
