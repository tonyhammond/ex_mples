defmodule NeoSemantics.Mapping do
  @moduledoc """
  Module providing simple wrapper functions for the [`neosemantics`](https://github.com/jbarrasa/neosemantics) library
  mapping functions.
  """

  @doc """
  Creates a reference to a vocabulary. Needed to define mappings.
  """
  def add_schema(conn, uri, prefix) do
    cypher = "call semantics.mapping.addSchema(\"" <> uri <> "\", \"" <> prefix <> "\")"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Deletes a vocabulary reference and all associated mappings.
  """
  def drop_schema(conn, uri) do
    cypher = "call semantics.mapping.importRDF(\"" <> uri <> "\")"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Returns all vocabulary references.
  """
  def list_schemas(conn, search_string \\ nil) do
    cypher =
      case search_string do
        nil -> "call semantics.mapping.listSchemas()"
        _ -> "call semantics.mapping.listSchemas(\"" <> search_string <> "\")"
      end
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
  def add_mapping_to_schema(conn, node, element1, element2) do
    cypher = "call semantics.mapping.addMappingToSchema(\"" <> node
    <> "\", \"" <> element1
    <> "\", \"" <> element2
    <> "\")"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Returns an output text message indicating success/failure of the deletion.
  """
  def drop_mapping(conn, element) do
    cypher = "call semantics.mapping.dropMapping(\"" <> element <> "\")"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Returns a list with all the mappings.
  """
  def list_mappings(conn, search_string \\ nil) do
    cypher =
      case search_string do
        nil -> "call semantics.mapping.listMappings()"
        _ -> "call semantics.mapping.listMappings(\"" <> search_string <> "\")"
      end
    Bolt.Sips.query!(conn, cypher)
  end

end
