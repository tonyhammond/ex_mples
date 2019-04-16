defmodule TestMatch do
  @moduledoc """
  """
  import Bolt.Sips, only: [conn: 0]

  @test_graph_file "default.ttl"
  @test_query_file "default.rq"

  @doc """
  Imports into Neo4j an LPG graph transformed from an RDF graph.

  ## Examples

      iex> TestMatch.import_rdf_from_graph("elixir.ttl")
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
    graph = TestMatch.RDF.read_graph(graph_file)
    conn() |> NeoSemantics.import_rdf!(graph.uri, "Turtle")
  end

  @doc """
  Imports into Neo4j an LPG graph transformed from an RDF graph which was
  queried from a remote datastore using a SPARQL endpoint.

  ## Examples

      iex> TestMatch.import_rdf_from_query("elixir.rq")
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
      TestMatch.RDF.read_query(query_file).data
      |> TestMatch.RDF.SPARQL.Client.rquery!
      |> RDF.Turtle.write_string!
      |> TestMatch.RDF.write_graph(graph_file)
    )
    conn() |> NeoSemantics.import_rdf!(graph.uri, "Turtle")
  end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is centered on a node identified by `node_id`.

  This returns the full context unless an optional boolean arg `exclude_context`
  is passed as `true` which will exclude context if present.

  ## Examples

      iex> TestMatch.export_rdf_by_id(1783)
      %TestMatch.Graph{
        data: "@prefix neovoc: <neo4j://defaultvocabulary#> .\\n@prefix neoind: <neo4j://indiv#> .\\n\\n\\nneoind:1783 a neovoc:Resource;\\n  neovoc:ns0__creator neoind:1785;\\n  neovoc:ns0__homepage neoind:1784;\\n  neovoc:ns0__license neoind:1786;\\n  neovoc:ns0__name \"Elixir\";\\n  neovoc:uri \"http://example.org/Elixir\" .\\n",
        file: "1783.ttl",
        path: "/Users/tony/Projects/github/tonyhammond/ex_mples/test_match/_build/dev/lib/test_graph/priv/rdf/graphs/1783.ttl",
        type: :rdf,
        uri: "file:///Users/tony/Projects/github/tonyhammond/ex_mples/test_match/_build/dev/lib/test_graph/priv/rdf/graphs/1783.ttl"
      }

      iex> TestMatch.export_rdf_by_id(1783).data
      "@prefix neovoc: <neo4j://defaultvocabulary#> .\\n@prefix neoind: <neo4j://indiv#> .\\n\\n\\nneoind:1783 a neovoc:Resource;\\n  neovoc:ns0__creator neoind:1785;\\n  neovoc:ns0__homepage neoind:1784;\\n  neovoc:ns0__license neoind:1786;\\n  neovoc:ns0__name \"Elixir\";\\n  neovoc:uri \"http://example.org/Elixir\" .\\n"

  """
  def export_rdf_by_id(node_id, exclude_context \\ false) do
    id = Integer.to_string(node_id)
    data = NeoSemantics.Extension.node_by_id(node_id, exclude_context)
    TestMatch.RDF.write_graph(data, id <> ".ttl")
  end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is centered on a node identified by `node_uri`.

  This returns the full context unless an optional boolean arg `exclude_context`
  is passed as `true` which will exclude context if present.

  ## Examples

      iex> TestMatch.export_rdf_by_uri("http://example.org/Elixir")
      %TestMatch.Graph{
        data: "@prefix neovoc: <neo4j://vocabulary#> .\\n\\n\\n<http://example.org/Elixir> <http://example.org/creator> <http://dbpedia.org/resource/José_Valim>;\\n  <http://example.org/homepage> <http://elixir-lang.org>;\\n  <http://example.org/license> <http://dbpedia.org/resource/Apache_License>;\\n  <http://example.org/name> \"Elixir\" .\\n",
        file: "http___example.org_Elixir.ttl",
        path: ... <> "/test_match/priv/rdf/graphs/http___example.org_Elixir.ttl",
        type: :rdf,
        uri: "file:\/\/\/" <> ... <> "/test_match/priv/rdf/graphs/http___example.org_Elixir.ttl"
      }

      iex> TestMatch.export_rdf_by_uri("http://example.org/Elixir").data
      "@prefix neovoc: <neo4j://vocabulary#> .\\n\\n\\n<http://example.org/Elixir> <http://example.org/creator> <http://dbpedia.org/resource/José_Valim>;\\n  <http://example.org/homepage> <http://elixir-lang.org>;\\n  <http://example.org/license> <http://dbpedia.org/resource/Apache_License>;\\n  <http://example.org/name> \"Elixir\" .\\n"

  """
  def export_rdf_by_uri(node_uri, exclude_context \\ false) do
    uri = URI.encode(node_uri)
    uri_safe  = String.replace(uri, ~r/[\/\?\:\@]/, "_")
    data = NeoSemantics.Extension.node_by_uri(node_uri, exclude_context)
    TestMatch.RDF.write_graph(data, uri_safe <> ".ttl")
  end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is defined by the `cypher` query.

  ## Examples

      iex> cypher = TestMatch.LPG.read_query("node1.cypher").data
      "match (n) return n limit 1\\n"
      iex> cypher |> TestMatch.export_rdf_by_query
  """
  def export_rdf_by_query(cypher, graph_file) do
    data = NeoSemantics.Extension.cypher(cypher)
    TestMatch.RDF.write_graph(data, graph_file)
  end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is defined by the `cypher` query.

  ## Examples

      iex> cypher =
      "match (n:Resource {uri:'http://dataset/indiv#153'}) return n\\n"
      iex> cypher |> TestMatch.export_rdf_by_query_on_rdf
  """
  def export_rdf_by_query_on_rdf(cypher, graph_file) do
    data = NeoSemantics.Extension.cypher_on_rdf(cypher)
    TestMatch.RDF.write_graph(data, graph_file)
  end

  # TestMatch.LPG delegates
  @doc "Delegates to TestMatch.LPG.books/0"
  defdelegate lpg_books(), to: TestMatch.LPG, as: :books
  @doc "Delegates to TestMatch.LPG.movies/0"
  defdelegate lpg_movies(), to: TestMatch.LPG, as: :movies

  @doc "Delegates to TestMatch.LPG.list_graphs/0"
  defdelegate list_lpg_graphs(), to: TestMatch.LPG, as: :list_graphs
  @doc "Delegates to TestMatch.LPG.list_queries/0"
  defdelegate list_lpg_queries(), to: TestMatch.LPG, as: :list_queries

  @doc "Delegates to TestMatch.LPG.read_graph/0"
  defdelegate read_lpg_graph(), to: TestMatch.LPG, as: :read_graph
  @doc "Delegates to TestMatch.LPG.read_graph/1"
  defdelegate read_lpg_graph(arg), to: TestMatch.LPG, as: :read_graph
  @doc "Delegates to TestMatch.LPG.read_query/0"
  defdelegate read_lpg_query(), to: TestMatch.LPG, as: :read_query
  @doc "Delegates to TestMatch.LPG.read_query/1"
  defdelegate read_lpg_query(arg), to: TestMatch.LPG, as: :read_query

  @doc "Delegates to TestMatch.LPG.write_graph/1"
  defdelegate write_lpg_graph(arg), to: TestMatch.LPG, as: :write_graph
  @doc "Delegates to TestMatch.LPG.write_graph/2"
  defdelegate write_lpg_graph(arg1, arg2), to: TestMatch.LPG, as: :write_graph
  @doc "Delegates to TestMatch.LPG.write_query/1"
  defdelegate write_lpg_query(arg), to: TestMatch.LPG, as: :write_query
  @doc "Delegates to TestMatch.LPG.write_query/2"
  defdelegate write_lpg_query(arg1, arg2), to: TestMatch.LPG, as: :write_query

  # TestMatch.RDF delegates
  @doc "Delegates to TestMatch.RDF.books/0"
  defdelegate rdf_books(), to: TestMatch.RDF, as: :books

  @doc "Delegates to TestMatch.RDF.list_graphs/0"
  defdelegate list_rdf_graphs(), to: TestMatch.RDF, as: :list_graphs
  @doc "Delegates to TestMatch.RDF.list_queries/0"
  defdelegate list_rdf_queries(), to: TestMatch.RDF, as: :list_queries

  @doc "Delegates to TestMatch.RDF.read_graph/0"
  defdelegate read_rdf_graph(), to: TestMatch.RDF, as: :read_graph
  @doc "Delegates to TestMatch.RDF.read_graph/1"
  defdelegate read_rdf_graph(arg), to: TestMatch.RDF, as: :read_graph
  @doc "Delegates to TestMatch.RDF.read_query/0"
  defdelegate read_rdf_query(), to: TestMatch.RDF, as: :read_query
  @doc "Delegates to TestMatch.RDF.read_query/1"
  defdelegate read_rdf_query(arg), to: TestMatch.RDF, as: :read_query

  @doc "Delegates to TestMatch.RDF.write_graph/1"
  defdelegate write_rdf_graph(arg), to: TestMatch.RDF, as: :write_graph
  @doc "Delegates to TestMatch.RDF.write_graph/2"
  defdelegate write_rdf_graph(arg1, arg2), to: TestMatch.RDF, as: :write_graph
  @doc "Delegates to TestMatch.RDF.write_query/1"
  defdelegate write_rdf_query(arg), to: TestMatch.RDF, as: :write_query
  @doc "Delegates to TestMatch.RDF.write_query/2"
  defdelegate write_rdf_query(arg1, arg2), to: TestMatch.RDF, as: :write_query

  # TestMatch.LPG.Cypher.Client delegates
  @doc "Delegates to TestMatch.LPG.Cypher.Client.rquery/0"
  defdelegate cypher(), to: TestMatch.LPG.Cypher.Client, as: :rquery
  @doc "Delegates to TestMatch.LPG.Cypher.Client.rquery/1"
  defdelegate cypher(arg), to: TestMatch.LPG.Cypher.Client, as: :rquery
  @doc "Delegates to TestMatch.LPG.Cypher.Client.rquery/0"
  defdelegate cypher!(), to: TestMatch.LPG.Cypher.Client, as: :rquery!
  @doc "Delegates to TestMatch.LPG.Cypher.Client.rquery/1"
  defdelegate cypher!(arg), to: TestMatch.LPG.Cypher.Client, as: :rquery!

  @doc "Delegates to TestMatch.LPG.Cypher.Client.clear/0"
  defdelegate cypher_clear(), to: TestMatch.LPG.Cypher.Client, as: :clear
  @doc "Delegates to TestMatch.LPG.Cypher.Client.dump/1"
  defdelegate cypher_dump(arg), to: TestMatch.LPG.Cypher.Client, as: :dump
  @doc "Delegates to TestMatch.LPG.Cypher.Client.dump/2"
  defdelegate cypher_dump(arg1, arg2), to: TestMatch.LPG.Cypher.Client, as: :dump
  @doc "Delegates to TestMatch.LPG.Cypher.Client.init/0"
  defdelegate cypher_init(), to: TestMatch.LPG.Cypher.Client, as: :init
  @doc "Delegates to TestMatch.LPG.Cypher.Client.reset/0"
  defdelegate cypher_reset(), to: TestMatch.LPG.Cypher.Client, as: :reset
  @doc "Delegates to TestMatch.LPG.Cypher.Client.test/0"
  defdelegate cypher_test(), to: TestMatch.LPG.Cypher.Client, as: :test

  # TestMatch.RDF.SPARQL  .Client delegates
  @doc "Delegates to TestMatch.RDF.SPARQL.Client.rquery/0"
  defdelegate sparql(), to: TestMatch.RDF.SPARQL.Client, as: :rquery
  @doc "Delegates to TestMatch.RDF.SPARQL.Client.rquery/1"
  defdelegate sparql(arg), to: TestMatch.RDF.SPARQL.Client, as: :rquery
  @doc "Delegates to TestMatch.RDF.SPARQL.Client.rquery/2"
  defdelegate sparql(arg1, arg2), to: TestMatch.RDF.SPARQL.Client, as: :rquery
  @doc "Delegates to TestMatch.RDF.SPARQL.Client.rquery/0"
  defdelegate sparql!(), to: TestMatch.RDF.SPARQL.Client, as: :rquery!
  @doc "Delegates to TestMatch.RDF.SPARQL.Client.rquery/1"
  defdelegate sparql!(arg), to: TestMatch.RDF.SPARQL.Client, as: :rquery!
  @doc "Delegates to TestMatch.RDF.SPARQL.Client.rquery/2"
  defdelegate sparql!(arg1, arg2), to: TestMatch.RDF.SPARQL.Client, as: :rquery!

  @doc "Delegates to TestMatch.RDF.SPARQL.Client.sparql_endpoint/0"
  defdelegate sparql_endpoint(), to: TestMatch.RDF.SPARQL.Client, as: :sparql_endpoint
  @doc "Delegates to TestMatch.RDF.SPARQL.Client.sparql_endpoint/1"
  defdelegate sparql_endpoint(arg), to: TestMatch.RDF.SPARQL.Client, as: :sparql_endpoint
  @doc "Delegates to TestMatch.RDF.SPARQL.Client.sparql_query/0"
  defdelegate sparql_query(), to: TestMatch.RDF.SPARQL.Client, as: :sparql_query
  @doc "Delegates to TestMatch.RDF.SPARQL.Client.sparql_query/1"
  defdelegate sparql_query(arg), to: TestMatch.RDF.SPARQL.Client, as: :sparql_query

  @doc "Delegates to TestMatch.RDF.SPARQL.Client.sparql_services/0"
  defdelegate list_sparql_services(), to: TestMatch.RDF.SPARQL.Client, as: :sparql_services

  @doc "Delegates to TestMatch.RDF.SPARQL.Client.dbpedia_sparql_endpoint/0"
  defdelegate dbpedia_sparql_endpoint(), to: TestMatch.RDF.SPARQL.Client, as: :dbpedia_sparql_endpoint
  @doc "Delegates to TestMatch.RDF.SPARQL.Client.local_sparql_endpoint/0"
  defdelegate local_sparql_endpoint(), to: TestMatch.RDF.SPARQL.Client, as: :local_sparql_endpoint
  @doc "Delegates to TestMatch.RDF.SPARQL.Client.wikidata_sparql_endpoint/0"
  defdelegate wikidata_sparql_endpoint(), to: TestMatch.RDF.SPARQL.Client, as: :wikidata_sparql_endpoint

end
