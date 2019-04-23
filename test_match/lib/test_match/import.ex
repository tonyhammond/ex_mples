defmodule TestMatch.Import do
  @moduledoc """
  Imports CSV data from priv/csv/
  """

  @priv_dir "#{:code.priv_dir(:test_match)}"

  @csv_dir @priv_dir <> "/csv/"

  @nodes_file "sw-nodes.csv"
  @relationships_file "sw-relationships.csv"

  def read_nodes_file(g, nodes_file \\ @nodes_file) do
    File.stream!(@csv_dir <> nodes_file)
    |> CSV.decode(separator: ?\,, headers: true)
    |> Enum.reduce(
      g,
      fn row, g ->
        {:ok, %{"id" => id}} = row
        Graph.add_vertex(g, id)
      end
    )
  end

  def read_relationships_file(g, relationships_file \\ @relationships_file ) do
    File.stream!(@csv_dir <> relationships_file)
    |> CSV.decode(separator: ?\,, headers: true)
    |> Enum.reduce(
      g,
      fn row, g ->
        {:ok, %{"dst" => dst, "relationship" => relationship, "src" => src}} = row
        Graph.add_edge(g, src, dst, label: relationship)
      end
    )
  end

end
