defmodule TestGraph.Graph do
  @moduledoc """
  Module providing a struct for graphs.
  """

  @priv_dir "#{:code.priv_dir(:test_graph)}"

  @lpg_dir @priv_dir <> "/lpg"
  @rdf_dir @priv_dir <> "/rdf"

  defstruct data: nil, file: nil, path: nil, type: nil, uri: nil

  @doc """
  Creates a `%TestGraph.Graph{}` struct.

  ## Examples

      iex> data |> TestGraph.Graph.new("books.ttl", :rdf)
      %TestGraph.Graph{
        data: "@prefix bibo: <http:\/\/purl.org\/ontology\/bibo\/> \\n" <> ...
        file: "books.ttl",
        path:  ... <> "\/test_graph\/priv\/rdf\/graphs\/books.ttl",
        type: :rdf,
        uri: "file:\/\/\/" <> ... <> "\/test_graph\/priv\/rdf\/graphs\/books.ttl"
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
      uri:  "file://" <> graphs_dir <> graph_file,
    }

  end

end
