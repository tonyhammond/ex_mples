defmodule TestGraph.RDF.SPARQL.Client do
  @moduledoc """
  Module providing simple wrapper functions for the `SPARQL.Client` module.
  """
  import TestGraph.RDF

  @hello_world "http://dbpedia.org/resource/Hello_World"

  @construct_query """
  construct
  { ?s ?p ?o }
  where {
  bind (<#{@hello_world}> as ?s)
  ?s ?p ?o
  filter (isLiteral(?o) && langMatches(lang(?o), "en"))
  }
  """

  @select_query """
  select *
  where {
  bind (<#{@hello_world}> as ?s)
  ?s ?p ?o
  filter (isLiteral(?o) && langMatches(lang(?o), "en"))
  }
  """

  @query_file_triples "triples.rq"
  @query_file_triples_by_uri "triples_by_uri.rq"

  @query @construct_query
  @service "http://dbpedia.org/sparql"

  ## Accessors for module attributes

  @doc """
  Returns default SPARQL query.
  """
  def default_sparql_query, do: @query

  @doc """
  Returns default SPARQL service.
  """
  def default_sparql_service, do: @service

  ## Accessors for env variables

  @doc """
  Returns current SPARQL query.
  """
  def sparql_query, do: Application.get_env(:test_graph, :sparql_query)

  @doc """
  Sets current SPARQL query.
  """
  def sparql_query(query) do
     Application.put_env(:test_graph, :sparql_query, query)
  end

  @doc """
  Returns current SPARQL service.
  """
  def sparql_service, do: Application.get_env(:test_graph, :sparql_service)

  @doc """
  Sets current SPARQL service.
  """
  def sparql_service(service) do
     Application.put_env(:test_graph, :sparql_service, service)
  end

  ## Hello query to test access to remote RDF datastore

  @doc """
  Queries default SPARQL service and prints out "Hello World".
  """
  def hello() do
    case SPARQL.Client.query(@select_query, @service) do
      {:ok, result} ->
        result.results |> Enum.each(&(IO.puts &1["o"]))
      {:error, reason} ->
        raise "! Error: #{reason}"
    end
  end

  ## Simple remote query functions

  @doc """
  Queries default SPARQL service with default SPARQL query.
  """
  def rquery() do
    SPARQL.Client.query(@query, @service)
  end

  @doc """
  The same as `rquery/0` but raises a runtime error if it fails.
  """
  def rquery!() do
    SPARQL.Client.query(@query, @service)
    |>
    case do
      {:ok, resp} -> resp
      {:error, error} -> raise error
    end
  end

  @doc """
  Queries default SPARQL service with user SPARQL query.
  """
  def rquery(query) do
    SPARQL.Client.query(query, @service)
  end

  @doc """
  The same as `rquery/1` but raises a runtime error if it fails.
  """
  def rquery!(query) do
    SPARQL.Client.query(query, @service)
    |>
    case do
      {:ok, resp} -> resp
      {:error, error} -> raise error
    end
  end

  @doc """
  Queries a user SPARQL service with a user SPARQL query.
  """
  def rquery(query, service) do
    SPARQL.Client.query(query, service)
  end

  @doc """
  The same as `rquery/2` but raises a runtime error if it fails.
  """
  def rquery!(query, service) do
    SPARQL.Client.query(query, service)
    |>
    case do
      {:ok, resp} -> resp
      {:error, error} -> raise error
    end
  end

  def triples(limit \\ nil) do
    case limit do
      nil -> rquery!(read_query(@query_file_triples).data)
      _ ->
        limit = Integer.to_string(limit)
        rquery!(read_query(@query_file_triples).data <> " limit " <> limit)
    end
  end

  def triples_by_uri(uri, limit \\ nil) do
    q = read_query(@query_file_triples_by_uri).data
    query = String.replace(q, "_uri", uri)
    case limit do
      nil -> rquery!(query)
      _ ->
        limit = Integer.to_string(limit)
        rquery!(query <> " limit " <> limit)
    end
  end

end
