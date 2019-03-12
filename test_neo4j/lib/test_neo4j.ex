defmodule TestNeo4j do
  @moduledoc """
  Documentation for TestNeo4j.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TestNeo4j.hello()
      :world

  """
  def hello do
    :world
  end

  @graphs_dir "#{:code.priv_dir(:test_neo4j)}/graphs/"
  @graphgists_dir "#{:code.priv_dir(:test_neo4j)}/graphgists/"
  @books_graph_file "books.cypher"
  @movies_graph_file "movies.cypher"
  @test_graphgist_file "graph_gist_template.adoc"

  def books() do
    File.read!(@graphs_dir <> @books_graph_file)
  end

  def movies() do
    File.read!(@graphs_dir <> @movies_graph_file)
  end

  def parse(graphgist) do
    result =
      Regex.run(~r/\/\/setup\n(\/\/hide\n)*\[source,cypher\]\n\-\-\-\-\n((.|\n)*)\-\-\-\-\n/Um, graphgist)
    result |>
    case do
      [_,cypher,_] -> cypher
      [_,_,cypher,_] -> cypher
    end
  end

  def graphgist() do
    File.read!(@graphgists_dir <> @test_graphgist_file)
  end

  def graphgist(graphgist_file) do
    File.read!(@graphgists_dir <> graphgist_file)
  end

  def init() do
    Bolt.Sips.conn
  end

  def clear(conn) do
    Bolt.Sips.query!(conn,
    """
    match (n) optional match (n)-[r]-() delete n,r
    """)
  end

  def reset(conn) do
    Bolt.Sips.query!(conn,
    """
    match (n) optional match (n)-[r]-() delete n,r
    """)
  end

  def test(conn) do
    Bolt.Sips.query!(conn,
    """
    match (n) optional match (n)-[r]-()
    return count(distinct n) as nodes, count(distinct r) as relationships
    """)
  end

end
