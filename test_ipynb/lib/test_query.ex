defmodule TestQuery do
  @moduledoc """
  Top-level module used in "Querying RDF with Elixir" post.

  This module provides test functions for the SPARQL module.
  """

  # @data_dir "#{:code.priv_dir(:test_query)}/data/"
  @data_dir "../tonyhammond/ex_mples/test_ipynb/priv/data/"
  @data_file "978-1-68050-252-7.ttl"

  @query """
  select *
  where {
    ?s ?p ?o
  }
  """

  ## Data query to test access to RDF file

  @doc """
  Reads default RDF model in Turtle format.
  """
  def data() do
    RDF.Turtle.read_file!(@data_dir <> @data_file)
  end

  ## Simple remote query functions

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

end
