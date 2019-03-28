defmodule TestGraph.RDF.NeoSemantics.Mapping do
  @moduledoc """
  Module providing simple wrapper functions for the `neosemantics` library
  mapping functions.
  """

  @doc """
  Creates a reference to a vocabulary. Needed to define mappings.
  """
  def add_schema(conn, uri, prefix) do
    cypher = "call semantics.mapping.addSchema(\"" <> uri <> "\", \"" <> prefix <> "\", {})"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Deletes a vocabulary reference and all associated mappings.
  """
  def drop_schema(conn, uri) do
    cypher = "call semantics.mapping.importRDF(\"" <> uri <> "\", {})"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Returns all vocabulary references.
  """
  def list_schemas(conn) do
    cypher = "call semantics.mapping.listSchemas()"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Returns all vocabulary references.
  """
  def list_schemas(conn, search_string) do
    cypher = "call semantics.mapping.listSchemas(\"" <> search_string <> "\")"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Creates a references to a number of popular vocabularies including schema.org, Dublin Core, SKOS, OWL, etc.
  """
  def add_common_schemas(conn) do
    cypher = "call semantics.mapping.addCommonSchemas()"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Creates a mapping for an element in the Neo4j DB schema to a vocabulary element.
  """
  def add_mapping_to_schema(conn, node, element, element) do
    cypher = "call semantics.mapping.addMappingToSchema(\"" <> node <> "\", \"" <> element <> "\", {})"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Returns an output text message indicating success/failure of the deletion.
  """
  def drop_mapping(conn, element) do
    cypher = "call semantics.mapping.dropMapping(\"" <> element <> "\", {})"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Returns a list with all the mappings.
  """
  def list_mappings(conn) do
    cypher = "call semantics.mapping.listMappings()"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Returns a list with all the mappings.
  """
  def list_mappings(conn, search_string) do
    cypher = "call semantics.mapping.listMappings(\"" <> search_string <> "\")"
    Bolt.Sips.query!(conn, cypher)
  end

end
