defmodule TestGraph.LPG do
  @moduledoc """
  Module providing a simple library for querying LPG models in a Neo4j instance via Cypher.
  """

  @priv_dir "#{:code.priv_dir(:test_graph)}"

  @lpg_dir @priv_dir <> "/lpg"

  @graphs_dir @lpg_dir <> "/graphs/"
  @queries_dir @lpg_dir <> "/queries/"

  ##

  @books_graph_file "books.cypher"
  @movies_graph_file "movies.cypher"

  @temp_graph_file "temp.cypher"
  @temp_query_file "temp.cypher"

  @test_graph_file "default.cypher"
  @test_query_file "default.cypher"

  ## graphs

  @doc """
  Lists Cypher graphs in the LPG graphs library.

  ## Examples

      iex> list_graphs()
      ["movies.cypher", "books.cypher", "default.cypher"]
  """
  def list_graphs() do
    File.ls!(@graphs_dir)
  end

  @doc """
  Lists Cypher queries in the LPG queries library.

  ## Examples

  ["relationship1.cypher", "node1_and_relationships.cypher", "path1.cypher",
   "paths.cypher", "relationship_ids.cypher", "relationships.cypher",
   "node_by_id.cypher", "default.cypher", "nodes.cypher", "node_id1.cypher",
   "node_ids.cypher", "nodes_and_relationships.cypher", "node1.cypher",
   "relationship_by_id.cypher"]
  """
  def list_queries() do
    File.ls!(@queries_dir)
  end

  @doc """
  Reads a user Turtle graph from the RDF graphs library.

  ## Examples

      iex> read_graph()
      %TestGraph.Graph{
        data: "\/\/\\n\/\/ create nodes\\n\/\/\\nCREATE\\n(book:Book {\\n" <> ...
        file: "default.cypher",
        path:  ... <> "\/test_graph\/priv\/lpg\/graphs\/default.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <> ... <> "\/test_graph\/priv\/lpg\/graphs\/default.cypher"
      }

      iex> read_graph("books.cypher")
      %TestGraph.Graph{
        data: "\/\/\\n\/\/ create nodes\\n\/\/\\nCREATE\\n(book:Book {\\n" <> ...
        file: "books.cypher",
        path:  ... <> "\/test_graph\/priv\/lpg\/graphs\/books.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <> ... <> "\/test_graph\/priv\/lpg\/graphs\/books.cypher"
      }
  """
  def read_graph(graph_file \\ @test_graph_file) do
    graphs_dir = @graphs_dir
    graph_data = File.read!(graphs_dir <> graph_file)

    TestGraph.Graph.new(graph_data, graph_file, :lpg)
  end

  @doc """
  Writes a Turtle graph to a user file in the RDF graphs library.

  ## Examples

      iex> data |> write_graph("my.cypher")
      %TestGraph.Graph{
        data: "\/\/\\n\/\/ create nodes\\n\/\/\\nCREATE\\n(book:Book {\\n" <> ...
        file: "my.cypher",
        path:  ... <> "\/test_graph\/priv\/lpg\/graphs\/my.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <>... <> "\/test_graph\/priv\/lpg\/graphs\/my.cypher"
      }

  """
  def write_graph(graph_data, graph_file \\ @temp_graph_file) do
    graphs_dir = @graphs_dir
    File.write!(graphs_dir <> graph_file, graph_data)

    TestGraph.Graph.new(graph_data, graph_file, :lpg)
  end

  ##

  @doc """
  Reads a `Books` graph from the graphs library.

  ## Examples

      iex> books().data
      "//\\n// create nodes\\n//\\nCREATE\\n(book:Book {\\n    iri: " <> ...

  """
  def books(), do: read_graph(@books_graph_file)

  @doc """
  Reads a `Movies` graph from the graphs library.

  ## Examples

      iex> movies().data
      "CREATE (TheMatrix:Movie {title:'The Matrix', released:1999," <> ...

  """
  def movies(), do: read_graph(@movies_graph_file)

  ## queries

  @doc """
  Reads a Cypher query from the LPG queries library.

  ## Examples

      iex> read_query()
      %TestGraph.Query{
        data: "match (n) return n\\n"
        file: "nodes.cypher",
        path:  ... <> "\/test_graph\/priv\/lpg\/queries\/nodes.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <> ... <> "\/test_graph\/priv\/lpg\/queries\/nodes.cypher"
      }

      iex> read_query("nodes.cypher")
      %TestGraph.Query{
        data: "match (n) return n\\n"
        file: "nodes.cypher",
        path:  ... <> "\/test_graph\/priv\/lpg\/queries\/nodes.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <> ... <> "\/test_graph\/priv\/lpg\/queries\/nodes.cypher"
      }
  """
  def read_query(query_file \\ @test_query_file) do
    queries_dir = @queries_dir
    query_data = File.read!(queries_dir <> query_file)

    TestGraph.Query.new(query_data, query_file, :lpg)
  end

  @doc """
  Writes a Cypher query to a file in the LPG queries library.

  ## Examples

      iex> write_query("my.cypher")
      %TestGraph.Query{
        data: "match (n) return n\\n"
        file: "my.cypher",
        path:  ... <> "\/test_graph\/priv\/lpg\/queries\/my.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <> ... <> "\/test_graph\/priv\/lpg\/queries\/my.cypher"
      }

  """
  def write_query(query_data, query_file \\ @temp_query_file) do
    queries_dir = @queries_dir
    File.write!(queries_dir <> query_file, query_data)

    TestGraph.Query.new(query_data, query_file, :lpg)
  end

end
