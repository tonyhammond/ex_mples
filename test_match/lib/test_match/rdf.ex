defmodule TestMatch.RDF do
  @moduledoc """
  Module for reading and writing a library of RDF graphs and SPARQL queries.

  The `read_graph/1` and `write_graph/2` functions allow for reading and writing
  RDF graphs to the project data repository. (Default file names are provided
  with the `read_graph/0` and `write_graph/1` forms.)
  The `list_graphs/0` function lists graph file names.

  The `read_query/1` and `write_query/2` functions allow for reading and writing
  SPARQL queries to the project data repository. (Default file names are provided
  with the `read_query/0` and `write_query/1` forms.)
  The `list_queries/0` function lists query file names.

  Some simple accessor functions are also available:

  * `graphs_dir/0`, `graph_file/0`, `temp_graph_file/0`
  * `queries_dir/0`, `query_file/0`, `temp_query_file/0`

  """

  @priv_dir "#{:code.priv_dir(:test_match)}"

  @rdf_dir @priv_dir <> "/rdf"

  @graphs_dir @rdf_dir <> "/graphs/"
  @queries_dir @rdf_dir <> "/queries/"

  @books_graph_file "books.ttl"

  @temp_graph_file "temp.ttl"
  @temp_query_file "temp.rq"

  @test_graph_file "default.ttl"
  @test_query_file "default.rq"

  @doc """
  Returns the LPG graphs directory.
  """
  def graphs_dir, do: @graphs_dir

  @doc """
  Returns the LPG queries directory.
  """
  def queries_dir, do: @queries_dir

  ##

  @doc """
  Returns a default RDF graph file.

  ## Examples

      iex> TestMatch.RDF.graph_file()
      "default.ttl"
  """
  def graph_file(), do: @test_graph_file

  @doc """
  Returns a default SPARQL query file.

  ## Examples

      iex> TestMatch.RDF.query_file()
      "default.rq"
  """
  def query_file(), do: @test_query_file

  @doc """
  Returns a temp RDF graph file for writing.

  ## Examples

      iex> TestMatch.RDF.temp_graph_file()
      "temp.ttl"
  """
  def temp_graph_file(), do: @temp_graph_file

  @doc """
  Returns a temp SPARQL query file for writing.

  ## Examples

      iex> TestMatch.RDF.temp_query_file()
      "temp.rq"
  """
  def temp_query_file(), do: @temp_query_file

  ##

  use RDF.Vocabulary.Namespace

  defvocab DC,
     base_iri: "http://purl.org/dc/elements/1.1/",
     terms: ~w[ creator date format publisher title ]

  defvocab BIBO,
     base_iri: "http://purl.org/ontology/bibo/",
     terms: ~w[ Book ]

   ## graphs

   @doc """
   Creates a `Book` graph.

   ## Examples

       iex> TestMatch.RDF.book()
       #RDF.Description{subject: ~I<urn:isbn:978-1-68050-252-7>
            ~I<http://purl.org/dc/elements/1.1/creator>
                ~I<https://twitter.com/bgmarx>
                ~I<https://twitter.com/josevalim>
                ~I<https://twitter.com/redrapids>
            ~I<http://purl.org/dc/elements/1.1/date>
                %RDF.Literal{value: ~D[2018-03-14], datatype: ~I<http://www.w3.org/2001/XMLSchema#date>}
            ~I<http://purl.org/dc/elements/1.1/format>
                ~L"Paper"
            ~I<http://purl.org/dc/elements/1.1/publisher>
                ~I<https://pragprog.com/>
            ~I<http://purl.org/dc/elements/1.1/title>
                ~L"Adopting Elixir"en
            ~I<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>
                ~I<http://purl.org/ontology/bibo/Book>}

   """
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

  @doc """
  Reads a `Books` graph from the graphs library.

  ## Examples

      iex> books().data
      ""<urn:isbn:978-1-68050-252-7>\\n    a <http://purl.org/ontology/bibo/Book> ;\\n ..."

  """
  def books(), do: read_graph(@books_graph_file)

  @doc """
  Lists RDF graphs in the RDF graphs library.

  ## Examples

      iex> list_graphs()
      ["books.ttl", "urn_isbn_978-1-68050-252-7.ttl",
       "http___dbpedia.org_resource_London.ttl", "london100.ttl", "london.ttl",
       "nobelprizes.ttl", "bibo.ttl", "temp.ttl",
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
  Reads a RDF graph from the RDF graphs library.

  ## Examples

      iex> read_graph()
      %TestMatch.Graph{
        data: "<http:\/\/dbpedia.org\/resource\/Hello_World>\\n..."
        file: "default.ttl",
        path: "...\/test_graph\/priv\/rdf\/graphs\/default.ttl",
        type: :rdf,
        uri: "file:\/\/\/...\/test_graph\/priv\/rdf\/graphs\/default.ttl"
      }

      iex> read_graph("books.ttl")
      %TestMatch.Graph{
        data: "@prefix bibo: <http:\/\/purl.org\/ontology\/bibo\/> \\n..."
        file: "books.ttl",
        path: "...\/test_graph\/priv\/rdf\/graphs\/books.ttl",
        type: :rdf,
        uri: "file:\/\/\/...\/test_graph\/priv\/rdf\/graphs\/books.ttl"
      }
  """
  def read_graph(graph_file \\ graph_file()) do
    graphs_dir = @graphs_dir
    graph_data = File.read!(graphs_dir <> graph_file)

    TestMatch.Graph.new(graph_data, graph_file, :rdf)
  end

  @doc """
  Writes a RDF graph to a file in the RDF graphs library.

  ## Examples

      iex> data |> write_graph("my.ttl")
      %TestMatch.Graph{
        data: "@prefix bibo: <http:\/\/purl.org\/ontology\/bibo\/> \\n..."
        file: "my.ttl",
        path: "\/test_graph\/priv\/rdf\/graphs\/my.ttl",
        type: :rdf,
        uri: "file:\/\/\/...\/test_graph\/priv\/rdf\/graphs\/my.ttl"
      }

  """
  def write_graph(graph_data, graph_file \\ temp_graph_file()) do
    graphs_dir = @graphs_dir
    File.write!(graphs_dir <> graph_file, graph_data)

    TestMatch.Graph.new(graph_data, graph_file, :rdf)
  end

  ##

  @doc """
  Reads a SPARQL query from the RDF queries library.

  ## Examples

      iex> read_query()
      %TestMatch.Query{
        data: "construct { ?s ?p ?o } where { ..."
        file: "books.rq",
        path: "...\/test_graph\/priv\/rdf\/queries\/books.rq",
        type: :rdf,
        uri: "file:\/\/\/...\/test_graph\/priv\/rdf\/queries\/books.rq"
      }

      iex> read_query("books.rq")
      %TestMatch.Query{
        data: "construct { ?s ?p ?o } where { ..."
        file: "books.rq",
        path: "...\/test_graph\/priv\/rdf\/queries\/books.rq",
        type: :rdf,
        uri: "file:\/\/\/...\/test_graph\/priv\/rdf\/queries\/books.rq"
      }
  """
  def read_query(query_file \\ query_file()) do
    queries_dir = @queries_dir
    query_data = File.read!(queries_dir <> query_file)

    TestMatch.Query.new(query_data, query_file, :rdf)
  end

  @doc """
  Writes a SPARQL query to a file in the RDF queries library.

  ## Examples

      iex> write_query("my.rq")
      %TestMatch.Query{
        data: "construct { ?s ?p ?o } where { ..."
        file: "my.rq",
        path: "...\/test_graph\/priv\/rdf\/queries\/my.rq",
        type: :rdf,
        uri: "file:\/\/\/...\/test_graph\/priv\/rdf\/queries\/my.rq"
      }

  """
  def write_query(query_data, query_file \\ temp_query_file()) do
    queries_dir = @queries_dir
    File.write!(queries_dir <> query_file, query_data)

    TestMatch.Query.new(query_data, query_file, :rdf)
  end

end
