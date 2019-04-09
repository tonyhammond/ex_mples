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

  use RDF.Vocabulary.Namespace

  defvocab DC,
     base_iri: "http://purl.org/dc/elements/1.1/",
     terms: ~w[ creator date format publisher title ]

  defvocab BIBO,
     base_iri: "http://purl.org/ontology/bibo/",
     terms: ~w[ Book ]

  def book() do
    import RDF.Sigils
    ~I<urn:isbn:978-1-68050-252-7>
    |> RDF.type(BIBO.Book)
    |> DC.creator(~I<https://twitter.com/bgmarx>,
         ~I<https://twitter.com/josevalim>,
         ~I<https://twitter.com/redrapids>)
    |> DC.date(RDF.date("2018-03-14"))
    |> DC.format(~L"Paper")
    |> DC.publisher(~I<https://pragprog.com/>)
    |> DC.title(~L"Adopting Elixir"en)
  end

  ## graphs

  @doc """
  Lists Turtle graphs in the RDF graphs library.

  ## Examples

      iex> list_graphs()
      ["books.ttl", "urn_isbn_978-1-68050-252-7.ttl",
       "http___dbpedia.org_resource_London.ttl", "london100.ttl", "london.ttl",
       "nobelprizes.ttl", "bibo.ttl", "tony.ttl", "temp.ttl",
       "http___example.org_Elixir.ttl", "elixir.ttl", "default.ttl", "cypher.ttl",
       "neo4j.ttl", "hello.ttl"]
  """
  def list_graphs() do
    File.ls!(@graphs_dir)
  end

  @doc """
  Lists SPARQL queries in the RDF queries library.

  ## Examples

      iex> list_queries()
      ["cypher.rq", "london.rq", "elixir.rq", "default.rq", "neo4j.rq",
       "triples_by_uri.rq", "triples.rq", "hello.rq"]
  """
  def list_queries() do
    File.ls!(@queries_dir)
  end

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
