defmodule TestGraph.RDF do
  @moduledoc """
  Module providing a simple library for manipulating and querying RDF models.
  """

  @priv_dir "#{:code.priv_dir(:test_graph)}"

  @rdf_dir @priv_dir <> "/rdf"

  @graphs_dir @rdf_dir <> "/graphs/"
  # @queries_dir @rdf_dir <> "/queries/"

  @books_graph_file "books.ttl"

  @temp_graph_file "temp.ttl"

  @test_graph_file "default.ttl"

  ##

  ## graphs

  @doc """
  Reads a default Turtle graph from the graphs library.

  ## Examples

      iex> read_graph()
      %TestGraph.Graph{
        data: "@prefix bibo: <http://purl.org/ontology/bibo/> .\n" ...
        file: "default.ttl",
        type: :rdf,
        uri: "file:///" <>... <> "/priv/lpg/graphs/default.ttl"
      }

  """
  def read_graph() do
    graph_file = @test_graph_file
    graphs_dir = @graphs_dir

    %TestGraph.Graph{
      data: File.read!(graphs_dir <> graph_file),
      file: graph_file,
      type: :rdf,
      uri:  "file://" <> graphs_dir <> graph_file,
    }
  end

  @doc """
  Reads a user Turtle graph from the graphs library.

  ## Examples

      iex> read_graph("books.ttl")
      %TestGraph.Graph{
        data: "@prefix bibo: <http://purl.org/ontology/bibo/> .\n" ...
        file: "books.ttl",
        type: :rdf,
        uri: "file:///" <>... <> "/priv/lpg/graphs/books.ttl"
      }

  """
  def read_graph(file: graph_file) do
    graphs_dir = @graphs_dir

    %TestGraph.Graph{
      data: File.read!(graphs_dir <> graph_file),
      file: graph_file,
      type: :rdf,
      uri:  "file://" <> graphs_dir <> graph_file,
    }
  end

  @doc """
  Writes a Turtle graph to a default file in the graphs library.

  ## Examples

      iex> write_graph(data)
      %TestGraph.Graph{
        data: "@prefix bibo: <http://purl.org/ontology/bibo/> .\n" ...
        file: "temp.ttl",
        type: :rdf,
        uri: "file:///" <>... <> "/priv/lpg/graphs/temp.ttl"
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
  Writes a Turtle graph to a user file in the graphs library.

  ## Examples

      iex> write_graph(data, file: "my.ttl")
      %TestGraph.Graph{
        data: "@prefix bibo: <http://purl.org/ontology/bibo/> .\n" ...
        file: "my.ttl",
        type: :rdf,
        uri: "file:///" <>... <> "/priv/lpg/graphs/my.ttl"
      }

  """
  def write_graph(data, file: graph_file) do
    graphs_dir = @graphs_dir

    File.write!(graphs_dir <> graph_file, data)
    %TestGraph.Graph{
      data: data,
      file: graph_file,
      type: :lpg,
      uri:  "file://" <> graphs_dir <> graph_file,
    }
  end
  
end
