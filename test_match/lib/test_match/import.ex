defmodule TestMatch.Import do
  @moduledoc """
  Module for importing CSV data from `priv/csv/`.
  """

  @priv_dir "#{:code.priv_dir(:test_match)}"

  @csv_dir @priv_dir <> "/csv/"

  @doc """
  Reads a CSV `nodes_file` and adds vertexes to the `Graph` `g` that is passed.

  The `nodes_file` is found at the `@csv_dir` location.

  ## Examples

      iex> import TestMatch.Import
      TestMatch.Import

      iex> g = Graph.new()
      #Graph<type: directed, vertices: [], edges: []>

      iex> g = read_nodes_file(g, "sw-nodes.csv")
      #Graph<type: directed, vertices: ["py4j", "jpy-client", "matplotlib",
       "nbconvert", "python-dateutil", "six", "jpy-console", "pyspark", "pytz",
       "spacy", "jupyter", "pandas", "ipykernel", "jpy-core", "numpy"], edges: []>
  """
  def read_nodes_file(g, nodes_file) do
    File.stream!(@csv_dir <> nodes_file)
    |> CSV.decode(separator: ?,, headers: true)
    |> Enum.reduce(
      g,
      fn row, g ->
        {:ok, %{"id" => id}} = row
        Graph.add_vertex(g, id)
      end
    )
  end

  @doc """
  Reads a CSV `relationships_file` and adds edges to the `Graph` `g` that is passed.

  The `relationships_file` is found at the `@csv_dir` location.

  ## Examples

      iex> g = read_relationships_file(g, "sw-relationships.csv")
      #Graph<type: directed, vertices: ["py4j", "jpy-client", "matplotlib",
       "nbconvert", "python-dateutil", "six", "jpy-console", "pyspark", "pytz",
       "spacy", "jupyter", "pandas", "ipykernel", "jpy-core",
       "numpy"], edges: ["jpy-client" -[DEPENDS_ON]-> "jpy-core", "matplotlib" -[DEPENDS_ON]-> "python-dateutil", "matplotlib" -[DEPENDS_ON]-> "six", "matplotlib" -[DEPENDS_ON]-> "pytz", "matplotlib" -[DEPENDS_ON]-> "numpy", "nbconvert" -[DEPENDS_ON]-> "jpy-core", "python-dateutil" -[DEPENDS_ON]-> "six", "jpy-console" -[DEPENDS_ON]-> "jpy-client", "jpy-console" -[DEPENDS_ON]-> "ipykernel", "pyspark" -[DEPENDS_ON]-> "py4j", "spacy" -[DEPENDS_ON]-> "six", "spacy" -[DEPENDS_ON]-> "numpy", "jupyter" -[DEPENDS_ON]-> "nbconvert", "jupyter" -[DEPENDS_ON]-> "jpy-console", "jupyter" -[DEPENDS_ON]-> "ipykernel", "pandas" -[DEPENDS_ON]-> "python-dateutil", "pandas" -[DEPENDS_ON]-> "pytz", "pandas" -[DEPENDS_ON]-> "numpy"]>
  """
  def read_relationships_file(g, relationships_file) do
    File.stream!(@csv_dir <> relationships_file)
    |> CSV.decode(separator: ?,, headers: true)
    |> Enum.reduce(
      g,
      fn row, g ->
        {:ok, %{"dst" => dst, "relationship" => relationship, "src" => src}} = row
        Graph.add_edge(g, src, dst, label: relationship)
      end
    )
  end
end
