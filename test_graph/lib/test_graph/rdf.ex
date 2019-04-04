defmodule TestGraph.RDF do
  @moduledoc """
  Module providing a simple library for manipulating and querying RDF models.
  """

  @priv_dir "#{:code.priv_dir(:test_graph)}"

  @rdf_dir @priv_dir <> "/rdf"

  @graphs_dir @rdf_dir <> "/graphs/"
  @queries_dir @rdf_dir <> "/queries/"

  @temp_graph_file "temp.ttl"
  @temp_query_file "temp.rq"

  @test_graph_file "default.ttl"
  @test_query_file "default.rq"

  ##

  ## graphs

  @doc """
  Reads a Turtle graph from the RDF graphs library.

  ## Examples

      iex> read_graph()
      %TestGraph.Graph{
        data: "<http:\/\/dbpedia.org\/resource\/Hello_World>\\n" <> ...
        file: "default.ttl",
        path:  ... <> "\/test_graph\/priv\/rdf\/graphs\/default.ttl",
        type: :rdf,
        uri: "file:\/\/\/" <> ... <> "\/test_graph\/priv\/rdf\/graphs\/default.ttl"
      }

      iex> read_graph("books.ttl")
      %TestGraph.Graph{
        data: "@prefix bibo: <http:\/\/purl.org\/ontology\/bibo\/> \\n" <> ...
        file: "books.ttl",
        path:  ... <> "\/test_graph\/priv\/rdf\/graphs\/books.ttl",
        type: :rdf,
        uri: "file:\/\/\/" <> ... <> "\/test_graph\/priv\/rdf\/graphs\/books.ttl"
      }
  """
  def read_graph(graph_file \\ @test_graph_file) do
    graphs_dir = @graphs_dir
    graph_data = File.read!(graphs_dir <> graph_file)

    TestGraph.Graph.new(graph_data, graph_file, :rdf)
  end

  @doc """
  Writes a Turtle graph to a file in the RDF graphs library.

  ## Examples

      iex> data |> write_graph("my.ttl")
      %TestGraph.Graph{
        data: "@prefix bibo: <http:\/\/purl.org\/ontology\/bibo\/> \\n" <> ...
        file: "my.ttl",
        path:  ... <> "\/test_graph\/priv\/rdf\/graphs\/my.ttl",
        type: :rdf,
        uri: "file:\/\/\/" <>... <> "\/test_graph\/priv\/rdf\/graphs\/my.ttl"
      }

  """
  def write_graph(graph_data, graph_file \\ @temp_graph_file) do
    graphs_dir = @graphs_dir
    File.write!(graphs_dir <> graph_file, graph_data)

    TestGraph.Graph.new(graph_data, graph_file, :rdf)
  end

  ##

  @doc """
  Reads a SPARQL query from the RDF queries library.

  ## Examples

      iex> read_query()
      %TestGraph.Query{
        data: "construct { ?s ?p ?o } where { " <> ...
        file: "books.rq",
        path:  ... <> "\/test_graph\/priv\/rdf\/queries\/books.rq",
        type: :rdf,
        uri: "file:\/\/\/" <> ... <> "\/test_graph\/priv\/rdf\/queries\/books.rq"
      }

      iex> read_query("books.rq")
      %TestGraph.Query{
        data: "construct { ?s ?p ?o } where { " <> ...
        file: "books.rq",
        path:  ... <> "\/test_graph\/priv\/rdf\/queries\/books.rq",
        type: :rdf,
        uri: "file:\/\/\/" <> ... <> "\/test_graph\/priv\/rdf\/queries\/books.rq"
      }
  """
  def read_query(query_file \\ @test_query_file) do
    queries_dir = @queries_dir
    query_data = File.read!(queries_dir <> query_file)

    TestGraph.Query.new(query_data, query_file, :rdf)
  end

  @doc """
  Writes a SPARQL query to a file in the RDF queries library.

  ## Examples

      iex> write_query("my.rq")
      %TestGraph.Query{
        data: "construct { ?s ?p ?o } where { " <> ...
        file: "my.rq",
        path:  ... <> "\/test_graph\/priv\/rdf\/queries\/my.rq",
        type: :rdf,
        uri: "file:\/\/\/" <> ... <> "\/test_graph\/priv\/rdf\/queries\/my.rq"
      }

  """
  def write_query(query_data, query_file \\ @temp_query_file) do
    queries_dir = @queries_dir
    File.write!(queries_dir <> query_file, query_data)

    TestGraph.Query.new(query_data, query_file, :rdf)
  end

end
