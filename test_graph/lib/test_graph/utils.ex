defmodule TestGraph.Utils do
  @moduledoc """
  Module providing helper functions.
  """

  @doc """
  Lists toplevel module's functions.

  ## Examples

      iex> help
      "[export_rdf_by_id: 1, export_rdf_by_id: 2, export_rdf_by_uri: 1, export_rdf_by_uri: 2, import_rdf_from_graph: 1, import_rdf_from_query: 1]"
  """
  def help() do
    inspect(TestGraph.__info__(:functions), limit: :infinity)
  end

  @doc """
  Lists named module's functions.

  ## Examples

      iex> help NeoSemantics
      "[import_rdf: 3, import_rdf!: 3, lite_onto_import: 3, lite_onto_import!: 3, preview_rdf: 3, preview_rdf!: 3, preview_rdf_snippet: 3, preview_rdf_snippet!: 3, stream_rdf: 3, stream_rdf!: 3]"

      iex> help NeoSemantics.Mapping
      "[add_common_schemas: 1, add_mapping_to_schema: 4, add_schema: 3, drop_mapping: 2, drop_schema: 2, list_mappings: 1, list_mappings: 2, list_schemas: 1, list_schemas: 2]"

      iex> help SPARQL.Client
      "[default_sparql_query: 0, default_sparql_service: 0, hello: 0, rquery: 0, rquery: 1, rquery: 2, rquery!: 0, rquery!: 1, rquery!: 2, sparql_query: 0, sparql_query: 1, sparql_service: 0, sparql_service: 1]"

  """
  def help(module) do
    inspect(module.__info__(:functions), limit: :infinity)
  end

end
