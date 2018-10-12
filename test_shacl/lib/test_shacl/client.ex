defmodule TestSHACL.Client do
  @moduledoc """
  This module provides test functions for the SPARQL.Client module.
  """

  @service "http://localhost:7200/repositories/shape-test"

  @query """
  select *
  where {
    ?s ?p ?o
  }
  """

  ## Accessor for module attribute

  def get_service, do: @service

  ## Simple remote query functions

  @doc """
  Queries default RDF service with default SPARQL query.
  """
  def rquery() do
    SPARQL.Client.query(@query, @service)
  end

  @doc """
  Queries default RDF service with user SPARQL query.
  """
  def rquery(query) do
    SPARQL.Client.query(query, @service)
  end

  @doc """
  Queries a user RDF service with a user SPARQL query.
  """
  def rquery(query, service) do
    SPARQL.Client.query(query, service)
  end

end
