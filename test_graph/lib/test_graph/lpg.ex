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
  Reads a user Turtle graph from the RDF graphs library.

  ## Examples

      iex> read_graph()
      %TestGraph.Graph{
        data: "\/\/\\n\/\/ create nodes\\n\/\/\\nCREATE\\n(book:Book {\\n" <> ...
        file: "default.cypher",
        path:  ... <> "\/priv\/lpg\/graphs\/default.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <> ... <> "\/priv\/lpg\/graphs\/default.cypher"
      }

      iex> read_graph("books.cypher")
      %TestGraph.Graph{
        data: "\/\/\\n\/\/ create nodes\\n\/\/\\nCREATE\\n(book:Book {\\n" <> ...
        file: "books.cypher",
        path:  ... <> "\/priv\/lpg\/graphs\/books.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <> ... <> "\/priv\/lpg\/graphs\/books.cypher"
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
        path:  ... <> "\/priv\/lpg\/graphs\/my.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <>... <> "\/priv\/lpg\/graphs\/my.cypher"
      }

  """
  def write_graph(data, graph_file \\ @temp_graph_file) do
    graphs_dir = @graphs_dir
    graph_data = File.write!(graphs_dir <> graph_file, data)

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
        path:  ... <> "\/priv\/lpg\/queries\/nodes.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <> ... <> "\/priv\/lpg\/queries\/nodes.cypher"
      }

      iex> read_query("nodes.cypher")
      %TestGraph.Query{
        data: "match (n) return n\\n"
        file: "nodes.cypher",
        path:  ... <> "\/priv\/lpg\/queries\/nodes.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <> ... <> "\/priv\/lpg\/queries\/nodes.cypher"
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
        path:  ... <> "\/priv\/lpg\/queries\/my.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <> ... <> "\/priv\/lpg\/queries\/my.cypher"
      }

  """
  def write_query(data, query_file \\ @temp_query_file) do
    queries_dir = @queries_dir
    query_data = File.write!(queries_dir <> query_file, data)

    TestGraph.Query.new(query_data, query_file, :lpg)
  end

end
