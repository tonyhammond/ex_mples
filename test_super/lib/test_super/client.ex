defmodule TestSuper.Client do
  @moduledoc """
  Module providing client-side functions for GenServer.
  """

  @priv_dir "#{:code.priv_dir(:test_super)}"

  @queries_dir @priv_dir <> "/queries/"
  @query_file "dbpedia_query.rq"

  @service "http://dbpedia.org/sparql"

  ## Calls

  @doc """
  Return map stored by GenServer with `pid`.
  """
  def get(pid) do
    GenServer.call(pid, {:get})
  end

  @doc """
  Return value for `key` stored by GenServer with `pid`.
  """
  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  @doc """
  Return list of keys for GenServer with `pid`.
  """
  def list(pid) do
    GenServer.call(pid, {:list})
  end

  @doc """
  Store `value` by `key` for GenServer with `pid`.
  """
  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  @doc """
  Store SPARQL query results for GenServer with `pid`.
  """
  def putq(pid) do
    {key, value} = _do_query()
    GenServer.cast(pid, {:put, key, value})
  end

  ## Queries

  @doc """
  Return default SPARQL query used for demo.
  """
  def query() do
    File.read!(@queries_dir <> @query_file)
  end

  @doc """
  Return default SPARQL endpoint used for demo.
  """
  def service(), do: @service

  @doc false
  defp _do_query() do
    # rewrite query with new random wikiPageID
    rand = Integer.to_string(Enum.random(1..50000))
    q = String.replace(query(), "12345", rand)

    # send query
    {:ok, result} = SPARQL.Client.query(q, @service)

    # parse query result set
    if length(result.results) == 0  do
      {rand, "(not found)"}
    else
      id = result |> SPARQL.Query.Result.get(:id) |> List.first
      s = result |> SPARQL.Query.Result.get(:s) |> List.first
      label = result |> SPARQL.Query.Result.get(:label) |> List.first
      topic = result |> SPARQL.Query.Result.get(:topic) |> List.first
      {id.value, {s.value, label.value, topic.value}}
    end
  end

end
