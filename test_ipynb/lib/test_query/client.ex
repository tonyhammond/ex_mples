defmodule TestQuery.Client do
  @moduledoc """
  This module provides test functions for the SPARQL.Client module.
  """

  @hello_world "http://dbpedia.org/resource/Hello_World"

  @query """
select *
where {
  bind (<#{@hello_world}> as ?s)
  ?s ?p ?o
  filter (isLiteral(?o) && langMatches(lang(?o), "en"))
}
"""

  # @query_dir "#{:code.priv_dir(:test_query)}/queries/"
  @query_dir "/Users/tony/Projects/github/tonyhammond/examples/test_ipynb/priv/queries/"

  @query_opts request_method: :get, protocol_version: "1.1"

  @service "http://dbpedia.org/sparql"

  ## Accessors for module attributes

  def get_query, do: @query
  def get_service, do: @service
  def get_query_opts, do: @query_opts

  ## Hello query to test access to remote RDF datastore

  @doc """
  Queries default RDF service and prints out "Hello World".
  """
  def hello() do
    case SPARQL.Client.query(@query, @service, @query_opts) do
      {:ok, result} ->
        # result.results |> Enum.each(&(IO.puts &1["o"]))
        result |> SPARQL.Query.Result.get(:o)
      {:error, reason} ->
        raise "! Error: #{reason}"
    end
  end

  ## Simple remote query functions

  @doc """
  Queries default RDF service with default SPARQL query.
  """
  def rquery() do
    SPARQL.Client.query(@query, @service, @query_opts)
  end


  @doc """
  Queries default RDF service with user SPARQL query.
  """
  def rquery(query) do
    SPARQL.Client.query(query, @service, @query_opts)
  end

  @doc """
  Queries a user RDF service with a user SPARQL query.
  """
  def rquery(query, service) do
    SPARQL.Client.query(query, service, @query_opts)
  end

  ## Demo of multiple SPARQL queries: from RQ files to ETS tables

  @doc """
  Queries default RDF service with saved SPARQL queries.

  This function also stores results in per-query ETS tables.
  """
  def rquery_all() do
    # get list of query files
    query_files =
      Path.wildcard(@query_dir <> "*.rq") |> Enum.map(&Path.basename/1)
    # iterate over query files and process
    for query_file <- query_files,
      do: _read_query(query_file) |> _get_data
  end

  defp _read_query(query_file) do
    # output a progress update
    IO.puts "Reading #{query_file}"

    # read query from query_file
    query =
      case File.open(@query_dir <> query_file, [:read]) do
        {:ok, file} ->
          IO.read(file, :all)
        {:error, reason} ->
          raise "! Error: #{reason}"
      end
    {query, Module.concat(__MODULE__, Path.basename(query_file, ".rq"))}
  end

  defp _get_data({query, table_name}),
    do: _get_data(query, table_name)

  defp _get_data(query, table_name) do
    # output a progress update
    IO.puts "Writing #{table_name}"

    # create ETS table
    :ets.new(table_name, [:named_table])

    # now call SPARQL endpoint and populate ETS table
    case SPARQL.Client.query(query, @service, @query_opts) do
      {:ok, result} ->
        result.results |> Enum.each(
          fn t -> :ets.insert(table_name, _build_spo_tuple(t)) end
        )
      {:error, reason} ->
        raise "! Error: #{reason}"
    end
  end

  defp _build_spo_tuple(t) do
    s = t["s"].value
    p = t["p"].value
    # need to test type of object term
    o =
      case t["o"] do
        %RDF.IRI{} -> t["o"].value
        %RDF.Literal{} -> t["o"].value
        %RDF.BlankNode{} -> t["o"].id
        _ -> raise "! Error: Could not get type of object term"
      end
    {System.os_time(), s, p, o, t}
  end

  ##

  @doc """
  Reads RDF data from ETS table and prints it.
  """
  def read_table(table_name) do
    :ets.tab2list(table_name) |> Enum.each(&_read_tuple/1)
  end

  defp _read_tuple(tuple) do
    {_, _, _, o, _} = tuple
    IO.puts o
  end

end
