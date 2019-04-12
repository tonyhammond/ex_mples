defmodule TestGraph.Query do
  @moduledoc """
  Module providing a struct for queries.

  The `%TestGraph.Query{}` struct is used to keep some related data fields
  together. One of the fields `:type` tracks whether this is a property
  graph query (`:lpg`) or a semantic graph query (`:rdf`).
  The other fields are straightforward data access fields:

  * `:data` – `query_data`
  * `:file` – name of `query_file` (within the `queries_dir`)
  * `:path` – absolute path of `query_file`
  * `:uri` – absolute URI of `query_file`

  ## Examples

      iex> data |> TestGraph.Query.new("temp.rq", :rdf)
      %TestGraph.Query{
        data: "<QUERY_DATA>"
        file: "temp.rq",
        path:  "...\/test_graph\/priv\/rdf\/queries\/temp.rq",
        type: :rdf,
        uri: "file:\/\/\/...\/test_graph\/priv\/rdf\/queries\/temp.rq"
      }

  """

  @priv_dir "#{:code.priv_dir(:test_graph)}"

  @lpg_dir @priv_dir <> "/lpg"
  @rdf_dir @priv_dir <> "/rdf"

  defstruct ~w[data file path type uri]a

  @doc """
  Creates a `%TestGraph.Query{}` struct.

  ## Examples

      iex> data |> TestGraph.Query.new("books.rq", :rdf)
      %TestGraph.Query{
        data: "@prefix bibo: <http:\/\/purl.org\/ontology\/bibo\/> \\n..."
        file: "books.rq",
        path:  "...\/test_graph\/priv\/rdf\/queries\/books.rq",
        type: :rdf,
        uri: "file:\/\/\/...\/test_graph\/priv\/rdf\/queries\/books.rq"
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
