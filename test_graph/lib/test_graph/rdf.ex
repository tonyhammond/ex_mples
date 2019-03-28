defmodule TestGraph.RDF do
  @moduledoc """
  Module providing a simple library for manipulating and querying RDF models.
  """

  @priv_dir "#{:code.priv_dir(:test_graph)}"

  @rdf_dir @priv_dir <> "/rdf"

  @graphs_dir @rdf_dir <> "/graphs/"
  # @queries_dir @rdf_dir <> "/queries/"

  @graph_file "978-1-68050-252-7.ttl"

  ##

  def graph_file, do: @graph_file

  def graph_file_uri() do
    "file://" <> @graphs_dir <> @graph_file
  end

  def graph_file_uri(graph_file) do
    "file://" <> @graphs_dir <> graph_file
  end

  def graph() do
    RDF.Turtle.read_file!(@graphs_dir <> @graph_file)
  end

  def graph(graph_file) do
    RDF.Turtle.read_file!(@graphs_dir <> graph_file)
  end

end
