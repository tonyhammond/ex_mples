defmodule TestGraph.RDF.SPARQL.Client do
  @moduledoc """
  This module provides test functions for the SPARQL.Client module.
  """

  @priv_dir "#{:code.priv_dir(:test_graph)}"

  @rdf_dir @priv_dir <> "/rdf"

  @graphs_dir @rdf_dir <> "/graphs/"
  @queries_dir @rdf_dir <> "/queries/"

  #

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

  @query @construct_query
  @service "http://dbpedia.org/sparql"

  ## Accessors for module attributes

  def get_query, do: @query
  def get_service, do: @service

  ## Hello query to test access to remote RDF datastore

  @doc """
  Queries default RDF service and prints out "Hello World".
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
  Queries default RDF service with default SPARQL query.
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
  Queries default RDF service with user SPARQL query.
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
  Queries a user RDF service with a user SPARQL query.
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


end
