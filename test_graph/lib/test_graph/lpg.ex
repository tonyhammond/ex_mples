defmodule TestGraph.LPG do
  @moduledoc """
  Module providing a simple library for querying LPG models in a Neo4j instance via Cypher.
  """

  @priv_dir "#{:code.priv_dir(:test_graph)}"

  @lpg_dir @priv_dir <> "/lpg"

  @graphs_dir @lpg_dir <> "/graphs/"
  @graphgists_dir @lpg_dir <> "/graphgists/"
  @queries_dir @lpg_dir <> "/queries/"

  ##

  @books_graph_file "books.cypher"
  @movies_graph_file "movies.cypher"

  @temp_graph_file "temp.cypher"

  @test_graph_file "default.cypher"
  @test_query_file "default.cypher"

  @test_graphgist_file "template.adoc"

  ## graphs

  @doc """
  Reads a default Cypher graph from the LPG graphs library.

  ## Examples

      iex> read_graph()
      %TestGraph.Graph{
        data: "\/\/\\n\/\/ create nodes\\n\/\/\\nCREATE\\n(book:Book {\\n" <> ...
        file: "default.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <>... <> "\/priv\/lpg\/graphs\/default.cypher"
      }

  """
  def read_graph() do
    graph_file = @test_graph_file
    graphs_dir = @graphs_dir

    %TestGraph.Graph{
      data: File.read!(graphs_dir <> graph_file),
      file: graph_file,
      type: :lpg,
      uri:  "file://" <> graphs_dir <> graph_file,
    }
  end

  @doc """
  Reads a user Cypher graph from the LPG graphs library.

  ## Examples

      iex> read_graph("books.cypher")
      %TestGraph.Graph{
        data: "\/\/\\n\/\/ create nodes\\n\/\/\\nCREATE\\n(book:Book {\\n" <> ...
        file: "books.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <>... <> "\/priv\/lpg\/graphs\/books.cypher"
      }

  """
  def read_graph(graph_file) do
    graphs_dir = @graphs_dir

    %TestGraph.Graph{
      data: File.read!(graphs_dir <> graph_file),
      file: graph_file,
      type: :lpg,
      uri:  "file://" <> graphs_dir <> graph_file,
    }
  end

  @doc """
  Writes a Turtle graph to a temp file in the LPG graphs library.

  ## Examples

      iex> data |> write_graph()
      %TestGraph.Graph{
        data: "\/\/\\n\/\/ create nodes\\n\/\/\\nCREATE\\n(book:Book {\\n" <> ...
        file: "temp.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <>... <> "\/priv\/lpg\/graphs\/temp.cypher"
      }

  """
  def write_graph(data) do
    graph_file = @temp_graph_file
    graphs_dir = @graphs_dir

    File.write!(graphs_dir <> graph_file, data)
    %TestGraph.Graph{
      data: data,
      file: graph_file,
      type: :lpg,
      uri:  "file://" <> graphs_dir <> graph_file,
    }
  end

  @doc """
  Writes a Cypher graph to a user file in the LPG graphs library.

  ## Examples

      iex> data |> write_graph("my.cypher")
      %TestGraph.Graph{
      data: "\/\/\\n\/\/ create nodes\\n\/\/\\nCREATE\\n(book:Book {\\n" <> ...
        file: "my.cypher",
        type: :lpg,
        uri: "file:\/\/\/" <>... <> "\/priv\/lpg\/graphs\/my.cypher"
      }

  """
  def write_graph(data, graph_file) do
    graphs_dir = @graphs_dir

    File.write!(graphs_dir <> graph_file, data)
    %TestGraph.Graph{
      data: data,
      file: graph_file,
      type: :lpg,
      uri:  "file://" <> graphs_dir <> graph_file,
    }
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

  ## graphgists

  @doc """
  Reads a default graphgist from the graphgists library.

  ## Examples

      iex> read_graphgist()
      "= REPLACEME: TITLE OF YOUR GRAPHGIST\\n:neo4j-version: 2.3.0\\n:author:" <> ...

  """
  def read_graphgist() do
    File.read!(@graphgists_dir <> @test_graphgist_file)
  end

  @doc """
  Reads a user graphgist from the graphgists library.

  ## Examples

      iex> read_graphgist("template.adoc")
      "= REPLACEME: TITLE OF YOUR GRAPHGIST\\n:neo4j-version: 2.3.0\\n:author:" <> ...

  """
  def read_graphgist(graphgist_file) do
    File.read!(@graphgists_dir <> graphgist_file)
  end

  @doc """
  Parses a graphgist to return a Cypher graph.

  ## Examples

      iex> parse(read_graphgist())
      "CREATE\\n  (a:Person {name: 'Alice'}),\\n  (b:Person {name: 'Bob'}),\\n" <> ...

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
  Reads a default Cypher query from the LPG queries library.

  ## Examples

      iex> read_query()
      "match (n) return n limit 1\\n"

  """
  def read_query() do
    File.read!(@queries_dir <> @test_query_file)
  end

  @doc """
  Reads a named Cypher query from the LPG queries library.

  ## Examples

      iex> read_query("nodes.cypher")
      "match (n) return n\\n"

  """
  def read_query(query_file) do
    File.read!(@queries_dir <> query_file)
  end

end
