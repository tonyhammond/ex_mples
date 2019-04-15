defmodule TestMatch.LPG do
  @moduledoc """
  Module for reading and writing a library of LPG graphs and Cypher queries.

  The `read_graph/1` and `write_graph/2` functions allow for reading and writing
  RDF graphs to the project data repository. (Default file names are provided
  with the `read_graph/0` and `write_graph/1` forms.)
  The `list_graphs/0` function lists graph file names.

  The `read_query/1` and `write_query/2` functions allow for reading and writing
  SPARQL queries to the project data repository. (Default file names are provided
  with the `read_query/0` and `write_query/1` forms.)
  The `list_queries/0` function lists query file names.

  The `books/0` and `movies/0` functions return LPG example graphs.

  Some simple accessor functions are also available:

  * `graphs_dir/0`, `graph_file/0`, `temp_graph_file/0`
  * `queries_dir/0`, `query_file/0`, `temp_query_file/0`

  """

  @priv_dir "#{:code.priv_dir(:test_match)}"

  @lpg_dir @priv_dir <> "/lpg"

  @graphs_dir @lpg_dir <> "/graphs/"
  @queries_dir @lpg_dir <> "/queries/"

  @doc """
  Returns the LPG graphs directory.
  """
  def graphs_dir, do: @graphs_dir

  @doc """
  Returns the LPG queries directory.
  """
  def queries_dir, do: @queries_dir

  ##

  @books_graph_file "books.cypher"
  @movies_graph_file "movies.cypher"

  @temp_graph_file "temp.cypher"
  @temp_query_file "temp.cypher"

  @test_graph_file "default.cypher"
  @test_query_file "default.cypher"

  ##

  @doc """
  Returns the default LPG graph file.

  ## Examples

      iex> TestMatch.LPG.graph_file()
      "default.cypher"
  """
  def graph_file(), do: @test_graph_file

  @doc """
  Returns the default Cypher query file.

  ## Examples

      iex> TestMatch.LPG.query_file()
      "default.cypher"
  """
  def query_file(), do: @test_query_file

  @doc """
  Returns the temp LPG graph file for writing.

  ## Examples

      iex> TestMatch.LPG.temp_graph_file()
      "temp.cypher"
  """
  def temp_graph_file(), do: @temp_graph_file

  @doc """
  Returns the temp Cypher query file for writing.

  ## Examples

      iex> TestMatch.LPG.temp_query_file()
      "temp.cypher"
  """
  def temp_query_file(), do: @temp_query_file

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

      iex> list_queries()
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
  Reads a user LPG graph from the LPG graphs library.

  ## Examples

      iex> read_graph()
      %TestMatch.Graph{
        data: "\/\/\\n\/\/ create nodes\\n\/\/\\nCREATE\\n(book:Book {\\n..."
        file: "default.cypher",
        path:  "...\/test_graph\/priv\/lpg\/graphs\/default.cypher",
        type: :lpg,
        uri: "file:\/\/\/...\/test_graph\/priv\/lpg\/graphs\/default.cypher"
      }

      iex> read_graph("books.cypher")
      %TestMatch.Graph{
        data: "\/\/\\n\/\/ create nodes\\n\/\/\\nCREATE\\n(book:Book {\\n..."
        file: "books.cypher",
        path: "...\/test_graph\/priv\/lpg\/graphs\/books.cypher",
        type: :lpg,
        uri: "file:\/\/\/...\/test_graph\/priv\/lpg\/graphs\/books.cypher"
      }
  """
  def read_graph(graph_file \\ graph_file()) do
    graphs_dir = @graphs_dir
    graph_data = File.read!(graphs_dir <> graph_file)

    TestMatch.Graph.new(graph_data, graph_file, :lpg)
  end

  @doc """
  Writes a LPG graph to a user file in the LPG graphs library.

  ## Examples

      iex> data |> write_graph("my.cypher")
      %TestMatch.Graph{
        data: "\/\/\\n\/\/ create nodes\\n\/\/\\nCREATE\\n(book:Book {\\n..."
        file: "my.cypher",
        path:  "...\/test_graph\/priv\/lpg\/graphs\/my.cypher",
        type: :lpg,
        uri: "file:\/\/\/...\/test_graph\/priv\/lpg\/graphs\/my.cypher"
      }

  """
  def write_graph(graph_data, graph_file \\ temp_graph_file()) do
    graphs_dir = @graphs_dir
    File.write!(graphs_dir <> graph_file, graph_data)

    TestMatch.Graph.new(graph_data, graph_file, :lpg)
  end

  ##

  @doc """
  Reads a `Books` graph from the graphs library.

  ## Examples

      iex> books().data
      "CREATE\\n(book:Book {\\n    iri: \\"urn:isbn:978-1-68050-252-7\\",\\n"

  """
  def books(), do: read_graph(@books_graph_file)

  @doc """
  Reads a `Movies` graph from the graphs library.

  ## Examples

      iex> movies().data
      "CREATE (TheMatrix:Movie {title:'The Matrix', released:1999,..."

  """
  def movies(), do: read_graph(@movies_graph_file)

  ## queries

  @doc """
  Reads a Cypher query from the LPG queries library.

  ## Examples

      iex> read_query()
      %TestMatch.Query{
        data: "match (n) return n\\n"
        file: "nodes.cypher",
        path: "...\/test_graph\/priv\/lpg\/queries\/nodes.cypher",
        type: :lpg,
        uri: "file:\/\/\/...\/test_graph\/priv\/lpg\/queries\/nodes.cypher"
      }

      iex> read_query("nodes.cypher")
      %TestMatch.Query{
        data: "match (n) return n\\n"
        file: "nodes.cypher",
        path: "...\/test_graph\/priv\/lpg\/queries\/nodes.cypher",
        type: :lpg,
        uri: "file:\/\/\/...\/test_graph\/priv\/lpg\/queries\/nodes.cypher"
      }
  """
  def read_query(query_file \\ query_file()) do
    queries_dir = @queries_dir
    query_data = File.read!(queries_dir <> query_file)

    TestMatch.Query.new(query_data, query_file, :lpg)
  end

  @doc """
  Writes a Cypher query to a file in the LPG queries library.

  ## Examples

      iex> write_query("my.cypher")
      %TestMatch.Query{
        data: "match (n) return n\\n"
        file: "my.cypher",
        path: "\/test_graph\/priv\/lpg\/queries\/my.cypher",
        type: :lpg,
        uri: "file:\/\/\/...\/test_graph\/priv\/lpg\/queries\/my.cypher"
      }

  """
  def write_query(query_data, query_file \\ temp_query_file()) do
    queries_dir = @queries_dir
    File.write!(queries_dir <> query_file, query_data)

    TestMatch.Query.new(query_data, query_file, :lpg)
  end

end
