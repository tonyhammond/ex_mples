defmodule TestSHACL do
  @moduledoc """
  Top-level module used in "Working with SHACL and Elixir" post.
  """

  @data_dir "#{:code.priv_dir(:test_shacl)}/data/"
  @data_file "978-1-68050-252-7.ttl"

  @shapes_dir "#{:code.priv_dir(:test_shacl)}/shapes/"
  @shape_file "book_shape.ttl"

  @shapes_queries_dir "#{:code.priv_dir(:test_shacl)}/shapes/queries/"
  @shape_query_file "book_shape_query.rq"
  @shape_query_helper_file "book_shape_query_helper.rq"

  @query """
  select *
  where {
    ?s ?p ?o
  }
  """

  ## Data access functions for graphs

  @doc """
  Reads RDF model in Turtle format.
  """
  def data() do
    RDF.Turtle.read_file!(@data_dir <> @data_file)
  end

  @doc """
  Reads RDF shape in Turtle format.
  """
  def shape() do
    RDF.Turtle.read_file!(@shapes_dir <> @shape_file)
  end

  ## Data access functions for queries

  @doc """
  Reads SPARQL query for RDF shape.
  """
  def shape_query() do
    File.read!(@shapes_queries_dir <> @shape_query_file)
  end

  def shape_query_helper() do
    File.read!(@shapes_queries_dir <> @shape_query_helper_file)
  end

  ## Simple query functions for testing

  @doc """
  Queries default RDF model with default SPARQL query.
  """
  def query() do
    query(@query)
  end

  @doc """
  Queries default RDF model with user SPARQL query.
  """
  def query(query) do
    RDF.Turtle.read_file!(@data_dir <> @data_file)
    |> SPARQL.execute_query(query)
  end

  @doc """
  Queries a user RDF model with a user SPARQL query.
  """
  def query(graph, query) do
    SPARQL.execute_query(graph, query)
  end

  ## Query builder

  @doc """
  Makes a SPARQL query by querying shape - for demo purposes only
  """
  def query_from_shape(shape, shape_query) do

    qh = "select ?s ?p ?o\nwhere {\n"
    qt = "}\n"

    result = SPARQL.execute_query(shape, shape_query)

    # add the subject type
    s = result |> SPARQL.Query.Result.get(:s) |> List.first
    q = qh <> "  ?s a <#{s}> .\n"

    # add the properties
    q = q <> List.to_string(
      result
      |> SPARQL.Query.Result.get(:p)
      |> Enum.map(&("  ?s <#{&1}> ?o .\n  ?s ?p ?o .\n"))
    )
    q <> qt

  end

  @doc """
  Makes a list of SPARQL queries by querying shape

  ## Examples
  
  iex> queries_from_shape(shape, shape_query)
  ...> |> Enum.map(&query/1)
  ...> Enum.map(&(to_graph(&1, :s, :p, :o))
  ...> List.foldl(RDF.Graph.new, fn g1, g2 -> RDF.Graph.add(g1, g2) end)

  """
  def queries_from_shape(shape, shape_query) do

    qh = "select ?s ?p ?o\nwhere {\n"
    qt = "}\n"

    result = SPARQL.execute_query(shape, shape_query)

    # get the subject
    s = result |> SPARQL.Query.Result.get(:s) |> List.first

    # get the properties
    (result |> SPARQL.Query.Result.get(:p))
    |> Enum.map(
      &(qh <> "  ?s a <#{s}> .\n  ?s <#{&1}> ?o .\n  ?s ?p ?o .\n" <> qt)
     )

  end

  ## Transform function from results table to graph

  @doc """
  Helper function to convert atom args to strings.
  """
  def to_graph(result, variable1, variable2, variable3)
      when is_atom(variable1) and is_atom(variable2) and is_atom(variable3),
    do: to_graph(result, to_string(variable1), to_string(variable2), to_string(variable3))

  @doc """
  Transforms a SPARQL.Query.Result struct into an RDF graph.
  """
  def to_graph(%SPARQL.Query.Result{results: results, variables: variables},
               variable1, variable2, variable3) do
    if variable1 in variables
      and variable2 in variables
      and variable3 in variables
    do
      triples =
        Enum.map results,
          fn r -> RDF.triple(r[variable1], r[variable2], r[variable3]) end
      RDF.graph(triples)
    end
  end

end
