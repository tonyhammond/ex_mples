defmodule NeoSemantics.Extension do
  @moduledoc """
  Module providing simple wrapper functions for the [`neosemantics`](https://github.com/jbarrasa/neosemantics) library
  extension functions.
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

      iex> NeoSemantics.Extension.node_by_id(1834)

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
    Tesla.get(base <> path <> query)
  end

  @doc """
  Exports from Neo4j an LPG graph transformed into an RDF graph. The graph
  is centered on a node identified by `node_uri`.

  This returns the full context unless an optional boolean arg `exclude_context`
  is passed as `true` which will exclude context if present.

  ## Examples

      iex> NeoSemantics.Extension.node_by_uri("http://example.org/Elixir")

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
    Tesla.get(base <> path <> query)
  end


end
