defmodule TestGraph.Query do
  @moduledoc """
  Module providing a struct for queries.
  """

  @priv_dir "#{:code.priv_dir(:test_graph)}"

  @lpg_dir @priv_dir <> "/rdf"
  @rdf_dir @priv_dir <> "/rdf"

  defstruct data: nil, file: nil, path: nil, type: nil, uri: nil

  @doc """
  Creates a `%TestGraph.Query{}` struct.

  ## Examples

      iex> data |> TestGraph.Query.new("books.rq", :rdf)
      %TestGraph.Query{
        data: "construct { ?s ?p ?o } where { " <> ...
        file: "books.rq",
        path:  ... <> "\/priv\/rdf\/queries\/books.rq",
        type: :rdf,
        uri: "file:\/\/\/" <> ... <> "\/priv\/rdf\/queries\/books.rq"
      }
  """
  def new(query_data, query_file, query_type) do

    queries_dir =
      case query_type do
        :lpg -> @lpg_dir <> "/queries/"
        :rdf -> @rdf_dir <> "/queries/"
        _ -> raise "! Unknown query_type: " <> query_type
      end

    %__MODULE__{
      data: query_data,
      file: query_file,
      path: queries_dir <> query_file,
      type: query_type,
      uri:  "file://" <> queries_dir <> query_file,
    }
  end

end
