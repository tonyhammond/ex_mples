defmodule TestQuery do
  @moduledoc """
  Test module used in "Querying RDF with Elixir" post
  """

  @data_file "978-1-68050-252-7.ttl"
  @data_dir "#{:code.priv_dir(:test_query)}/data/"

  @query """
  select *
  where {
    ?s ?p ?o
  }
  """

  @doc """
  hello/0 - Prints out default RDF model in Turtle format
  """
  def hello() do
    RDF.Turtle.read_file!(@data_dir <> @data_file)
    |> RDF.Turtle.write_string!
    |> IO.puts
  end

  @doc """
  query/0 - Queries default RDF model with default SPARQL query
  """
  def query() do
    query(@query)
  end

  @doc """
  query/1 - Queries default RDF model with user SPARQL query
  """
  def query(query) do
    graph = RDF.Turtle.read_file!(@data_dir <> @data_file)
    SPARQL.execute_query(graph, query)
  end

  @doc """
  query/2 - Queries a user RDF model with a user SPARQL query

  This essentially is nothing more than a wrapper for SPARQL.execute_query
  """
  def query(graph, query) do
    SPARQL.execute_query(graph, query)
  end

end
