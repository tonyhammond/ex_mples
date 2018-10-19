defmodule TestSuper.Client do
  @moduledoc """
  Module providing client-side functions for `GenServer`.
  """

  @priv_dir "#{:code.priv_dir(:test_super)}"

  @queries_dir @priv_dir <> "/queries/"
  @query_file "dbpedia_query.rq"

  @service "http://dbpedia.org/sparql"

  ## Calls

  @doc """
  Return map stored by `GenServer` with process ID `pid`.

  ## Examples

      iex> get(pid)
      %{baz: 123, foo: "bar"}

      iex> get(pid)
      %{
      49631 => {"http://dbpedia.org/resource/Turner's_syndrome",
      "Turner's syndrome",
      "http://en.wikipedia.org/wiki/Turner's_syndrome"}
      }
  """
  def get(pid) do
    GenServer.call(pid, {:get})
  end

  @doc """
  Return value for `key` stored by `GenServer` with process ID `pid`.

  ## Examples

      iex> get(pid, :foo)
      "bar"

      iex> get(pid, 49631)
      {"http://dbpedia.org/resource/Turner's_syndrome", "Turner's
      syndrome", "http://en.wikipedia.org/wiki/Turner's_syndrome"}
  """
  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  @doc """
  Return list of keys for `GenServer` with process ID `pid`.

  ## Examples

      iex> keys(pid)
      [1788, 4417, 9442, 23921]
  """
  def keys(pid) do
    GenServer.call(pid, {:keys})
  end

  @doc """
  Store `value` by `key` for `GenServer` with process ID `pid`.

  ## Examples

      iex> put(pid, :baz, 123)
      :ok
  """
  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  @doc """
  Store SPARQL query results for `GenServer` with process ID `pid`.

  ## Examples

      iex> putq(pid)
      49631 => {"http://dbpedia.org/resource/Turner's_syndrome", "Turner's
      syndrome", "http://en.wikipedia.org/wiki/Turner's_syndrome"}
      :ok
  """
  def putq(pid) do
    {key, value} = _do_query()
    IO.puts "#{inspect key} => #{inspect value}"
    GenServer.cast(pid, {:put, key, value})
  end

  ## Queries

  @doc """
  Return default SPARQL query used for demo.

  ## Examples

      iex> query
      "prefix dbo: <http://dbpedia.org/ontology/>\\nprefix foaf: ..."

  """
  def query() do
    File.read!(@queries_dir <> @query_file)
  end

  @doc """
  Return default SPARQL endpoint used for demo.

  ## Examples

      iex> service
      "http://dbpedia.org/sparql"
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
