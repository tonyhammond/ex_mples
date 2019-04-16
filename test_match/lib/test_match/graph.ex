defmodule TestMatch.Graph do
  @moduledoc """
  Module providing a struct for graphs.

  The `%TestMatch.Graph{}` struct is used to keep some related data fields
  together. One of the fields `:type` tracks whether this is a property
  graph (`:lpg`) or a semantic graph (`:rdf`).
  The other fields are straightforward data access fields:

  * `:data` – `graph_data`
  * `:file` – name of `graph_file` (within the `graphs_dir`)
  * `:path` – absolute path of `graph_file`
  * `:uri` – absolute URI of `graph_file`

  ## Examples

      iex> data |> TestMatch.Graph.new("temp.ttl", :rdf)
      %TestMatch.Graph{
        data: "<GRAPH_DATA>"
        file: "temp.ttl",
        path:  "...\/test_match\/priv\/rdf\/graphs\/temp.ttl",
        type: :rdf,
        uri: "file:\/\/\/...\/test_match\/priv\/rdf\/graphs\/temp.ttl"
      }

  """

  @priv_dir "#{:code.priv_dir(:test_match)}"

  @lpg_dir @priv_dir <> "/lpg"
  @rdf_dir @priv_dir <> "/rdf"

  defstruct ~w[data file path type uri]a

  @doc """
  Creates a `%TestMatch.Graph{}` struct.

  ## Examples

      iex> data |> TestMatch.Graph.new("books.ttl", :rdf)
      %TestMatch.Graph{
        data: "@prefix bibo: <http:\/\/purl.org\/ontology\/bibo\/> \\n..."
        file: "books.ttl",
        path:  "...\/test_match\/priv\/rdf\/graphs\/books.ttl",
        type: :rdf,
        uri: "file:\/\/\/...\/test_match\/priv\/rdf\/graphs\/books.ttl"
      }
  """
  def new(graph_data, graph_file, graph_type) do
    graphs_dir =
      case graph_type do
        :lpg -> @lpg_dir <> "/graphs/"
        :rdf -> @rdf_dir <> "/graphs/"
        _ -> raise "! Unknown graph_type: " <> graph_type
      end

    %__MODULE__{
      data: graph_data,
      file: graph_file,
      path: graphs_dir <> graph_file,
      type: graph_type,
      uri: "file://" <> graphs_dir <> graph_file
    }
  end
end
