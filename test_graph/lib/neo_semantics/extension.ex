defmodule NeoSemantics.Extension do
  @moduledoc """
  Module providing simple wrapper functions for the [`neosemantics`](https://github.com/jbarrasa/neosemantics) library
  extension functions.

  TODO - format support

  """
  ##

  @doc """
  Pings the Neo4j service.

  This returns a JSON confirmation that the service is up.

  ## Examples

      iex> NeoSemantics.Extension.ping
      {"ping":"here!"}
      :ok

  """
  def ping() do
    # method = :get
    base = Application.get_env(:test_graph, :neo4j_service)
    path = "/rdf/ping"
    {:ok, env} = Tesla.get(base <> path)
    IO.puts env.body
  end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is centered on a node identified by `node_id`.

  This returns the full context unless an optional boolean arg `exclude_context`
  is passed as `true` which will exclude context if present.

  ## Examples

      iex> NeoSemantics.Extension.node_by_id(1783)
      "@prefix neovoc: <neo4j://defaultvocabulary#> .\\n@prefix neoind: <neo4j://indiv#> .\\n\\n\\nneoind:1783 a neovoc:Resource;\\n  neovoc:ns0__creator neoind:1785;\\n  neovoc:ns0__homepage neoind:1784;\\n  neovoc:ns0__license neoind:1786;\\n  neovoc:ns0__name \"Elixir\";\n  neovoc:uri \"http://example.org/Elixir\" .\\n"

  """
  def node_by_id(node_id, exclude_context \\ false) do
    id = Integer.to_string(node_id)
    base = Application.get_env(:test_graph, :neo4j_service)
    path = "/rdf/describe/id"
    query =
      case exclude_context do
        true -> "?nodeid=" <> id <> "&excludeContext"
        false -> "?nodeid=" <> id
      end
      {:ok, env} = Tesla.get(base <> path <> query, headers: [{"accept", "text/turtle"}])
      env.body
  end

  # @doc """
  # """
  # def node_by_id2(node_id, exclude_context \\ false) do
  # end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is centered on a node identified by `node_uri`.

  This returns the full context unless an optional boolean arg `exclude_context`
  is passed as `true` which will exclude context if present.

  ## Examples

      iex> NeoSemantics.Extension.node_by_uri("http://example.org/Elixir")
      "@prefix neovoc: <neo4j://vocabulary#> .\\n\\n\\n<http://example.org/Elixir> <http://example.org/creator> <http://dbpedia.org/resource/José_Valim>;\\n  <http://example.org/homepage> <http://elixir-lang.org>;\\n  <http://example.org/license> <http://dbpedia.org/resource/Apache_License>;\\n  <http://example.org/name> \"Elixir\" .\\n"

  """
  def node_by_uri(node_uri, exclude_context \\ false) do
    uri = URI.encode(node_uri)
    base = Application.get_env(:test_graph, :neo4j_service)
    path = "/rdf/describe/uri"
    query =
      case exclude_context do
        true -> "?nodeuri=" <> uri <> "&excludeContext"
        false -> "?nodeuri=" <> uri
      end
    {:ok, env} = Tesla.get(base <> path <> query, headers: [{"accept", "text/turtle"}])
    env.body
  end


  @doc """
  Produces an RDF serialization of the nodes and relationships returned by the query.

  Currently only RDF Turtle is supported. Also have a problem with supporting the `showOnlyMapped` parameter.

  ## Examples

      iex> cypher = TestGraph.LPG.read_query("node1.cypher").data
      "match (n) return n limit 1\\n"
      iex> IO.puts (cypher |> NeoSemantics.Extension.cypher_on_lpg)
      @prefix neovoc: <neo4j://defaultvocabulary#> .
      @prefix neoind: <neo4j://indiv#> .


      neoind:919 a neovoc:Resource;
        neovoc:rdfs__label "Hello World";
        neovoc:uri "http://dbpedia.org/resource/Hello_World" .

      :ok
  """
  def cypher_on_lpg(cypher, showOnlyMapped \\ false) do
    base = Application.get_env(:test_graph, :neo4j_service)
    path = "/rdf/cypher"
    # data = Jason.encode!(%{"cypher" => cypher, "showOnlyMapped" => showOnlyMapped})
    data = Jason.encode!(%{"cypher" => cypher})

    {:ok, env} = Tesla.post(base <> path, data, headers: [{"accept", "text/turtle"}])
    env.body
  end

  @doc """
  Produces an RDF serialization of the nodes and relationships returned by the query.

  Currently only RDF Turtle is supported.

  ## Examples

      iex> cypher = TestGraph.LPG.read_query("nodes.cypher").data
      "match (n) return distinct n\\n"
      iex> cypher |> NeoSemantics.Extension.cypher_on_rdf

  """
  def cypher_on_rdf(cypher) do
    base = Application.get_env(:test_graph, :neo4j_service)
    path = "/rdf/cypheronrdf"
    data = Jason.encode!(%{"cypher" => cypher})

    {:ok, env} = Tesla.post(base <> path, data, headers: [{"accept", "text/turtle"}])
    env.body
  end

end
