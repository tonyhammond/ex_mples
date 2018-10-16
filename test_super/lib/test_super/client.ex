defmodule TestSuper.Client do
  @moduledoc """
  Documentation for TestSuper.Client.
  """

  @priv_dir "#{:code.priv_dir(:test_super)}"

  @queries_dir @priv_dir <> "/queries/"
  @query_file "dbpedia_query.rq"

  @service "http://dbpedia.org/sparql"

  ## Calls

  def new() do
    { :ok, pid } = DynamicSupervisor.start_child(
        TestSuper.Supervisor, TestSuper.Server
      )
    pid
  end

  def get(pid) do
    GenServer.call(pid, {:get})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def list(pid) do
    GenServer.call(pid, {:list})
  end

  def put(pid, key, value) do
    IO.inspect key
    IO.inspect value
    GenServer.cast(pid, {:put, key, value})
  end

  def putq(pid) do
    {key, value} = _do_query()
    IO.inspect key
    IO.inspect value
    GenServer.cast(pid, {:put, key, value})
  end

  ## Queries

  def query() do
    File.read!(@queries_dir <> @query_file)
  end

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
