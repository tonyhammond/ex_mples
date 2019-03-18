defmodule TestNeo4j do
  @moduledoc """
  Top-level module used in "Property graphs in Elixir" post.
  """

  @priv_dir "#{:code.priv_dir(:test_neo4j)}"

  @graphs_dir @priv_dir <> "/graphs/"
  @graphgists_dir @priv_dir <> "/graphgists/"
  @queries_dir @priv_dir <> "/queries/"

  @books_graph_file "books.cypher"
  @movies_graph_file "movies.cypher"

  @test_graph_file "books.cypher"
  @test_graphgist_file "template.adoc"
  @test_query_file "get_one_node.cypher"

  ## graphs

  @doc """
  Reads a default Cypher graph from the graphs library.
  """
  def read_graph() do
    File.read!(@graphgists_dir <> @test_graph_file)
  end

  @doc """
  Reads a user Cypher graph from the graphs library.
  """
  def read_graph(graph_file) do
    File.read!(@graphs_dir <> graph_file)
  end

  @doc """
  Reads a Books graph from the graphs library.
  """
  def books() do
    File.read!(@graphs_dir <> @books_graph_file)
  end

  @doc """
  Reads a Movies graph from the graphs library.
  """
  def movies() do
    File.read!(@graphs_dir <> @movies_graph_file)
  end

  ## graphgists

  @doc """
  Reads a default graphgist from the graphgists library.
  """
  def read_graphgist() do
    File.read!(@graphgists_dir <> @test_graphgist_file)
  end

  @doc """
  Reads a user graphgist from the graphgists library.
  """
  def read_graphgist(graphgist_file) do
    File.read!(@graphgists_dir <> graphgist_file)
  end

  @doc """
  Parses a graphgist to return a Cypher graph.
  """
  def parse(graphgist) do
    Regex.run(
      ~r/\/setup\n(\/\/hide\n)*(\/\/output\n)*\[source,\s*cypher\]\n\-\-\-\-.*\n((.|\n)*)\-\-\-\-.*\n/Um,
      graphgist
    )
    |> case do
      [_, cypher, _] -> cypher       # //hide\n
      [_, _, cypher, _] -> cypher    # //hide\n//output]\n
      [_, _, _, cypher, _] -> cypher
      _ -> ""
    end
  end

  ## queries

  @doc """
  Reads a default Cypher query from the queries library.
  """
  def read_query() do
    File.read!(@queries_dir <> @test_query_file)
  end

  @doc """
  Reads a named Cypher query from the queries library.
  """
  def read_query(query_file) do
    File.read!(@queries_dir <> query_file)
  end

  @doc """
  Queries database for one node.
  """
  def node1(conn) do
    Bolt.Sips.query!(conn, read_query("node1.cypher"))
  end

  @doc """
  Queries database for all nodes.
  """
  def nodes(conn) do
    Bolt.Sips.query!(conn, read_query("nodes.cypher"))
  end

  @doc """
  Queries database for one relationship.
  """
  def relationship1(conn) do
    Bolt.Sips.query!(conn, read_query("relationship1.cypher"))
  end

  @doc """
  Queries database for all relationships.
  """
  def relationships(conn) do
    Bolt.Sips.query!(conn, read_query("relationships.cypher"))
  end

  @doc """
  Queries database for one node and relationships.
  """
  def node1_and_relationships(conn) do
    Bolt.Sips.query!(conn, read_query("node1_and_relationships.cypher"))
  end

  @doc """
  Queries database for all nodes and relationships.
  """
  def nodes_and_relationships(conn) do
    Bolt.Sips.query!(conn, read_query("nodes_and_relationships.cypher"))
  end

  @doc """
  Queries database for one path.
  """
  def path1(conn) do
    Bolt.Sips.query!(conn, read_query("path1.cypher"))
  end

  @doc """
  Queries database for all paths.
  """
  def paths(conn) do
    Bolt.Sips.query!(conn, read_query("paths.cypher"))
  end

  ## database
  @doc """
  Opens up a Bolt database connection with the app config.
  """
  def init() do
    Application.get_env(:bolt_sips, Bolt)
    |> Bolt.Sips.start_link()

    Bolt.Sips.config()
  end

  @doc """
  Deletes all nodes and relationships in database.
  """
  def clear(conn) do
    Bolt.Sips.query!(
      conn,
      """
      match (n) optional match (n)-[r]-() delete n,r
      """
    )
  end

  @doc """
  Deletes all nodes and relationships in database.
  """
  def reset(conn) do
    Bolt.Sips.query!(
      conn,
      """
      match (n) optional match (n)-[r]-() delete n,r
      """
    )
  end

  @doc """
  Counts nodes, relationships and paths in database.
  """
  def test(conn) do
    Bolt.Sips.query!(
      conn,
      """
      match (n) optional match p = (n)-[r]-()
      return
      count(distinct n) as nodes,
      count(distinct r) as relationships,
      count(distinct p) as paths
      """
    )
  end

end
