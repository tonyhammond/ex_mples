defmodule TestMatch.Lib do
  @moduledoc """
  Module for reading and writing a library of `libgraph` graphs.

  The `read_graph/1` and `write_graph/2` functions allow for reading and writing
  RDF graphs to the project data repository. (Default file names are provided
  with the `read_graph/0` and `write_graph/1` forms.)
  The `list_graphs/0` function lists graph file names.

  Some simple accessor functions are also available:

  * `graphs_dir/0`, `graph_file/0`, `temp_graph_file/0`

  """

  @priv_dir "#{:code.priv_dir(:test_match)}"

  @lib_dir @priv_dir <> "/lib"

  @graphs_dir @lib_dir <> "/graphs/"
  @graph_images_dir @lib_dir <> "/graphs/images/"

  @temp_graph_file "temp.dot"

  @test_graph_file "default.dot"

  @node_table Module.concat(__MODULE__, "node_properties")
  @edge_table Module.concat(__MODULE__, "edge_properties")

  @doc """
  Returns the Lib graphs directory.
  """
  def graphs_dir, do: @graphs_dir

  ##

  @dot_binary "/usr/local/bin/dot"
  @neato_binary "/usr/local/bin/neato"
  @twopi_binary "/usr/local/bin/twopi"
  @circo_binary "/usr/local/bin/circo"
  @fdp_binary "/usr/local/bin/fdp"
  @sfdp_binary "/usr/local/bin/sfdp"
  @patchwork_binary "/usr/local/bin/patchwork"
  @osage_binary "/usr/local/bin/osage"

  @cypher_query "match (n)-[r]->(o) return n,r,o"
  @sparql_query "select * where {?s ?p ?o}"

  @doc """
  Returns a default Cypher query.
  """
  def cypher_query(), do: @cypher_query

  @doc """
  Returns a default SPARQL query.
  """
  def sparql_query(), do: @sparql_query

  ##

  @doc """
  Returns a default Lib graph file.

  ## Examples

      iex> TestMatch.Lib.graph_file()
      "default.ttl"
  """
  def graph_file(), do: @test_graph_file

  @doc """
  Returns a temp Lib graph file for writing.

  ## Examples

      iex> TestMatch.Lib.temp_graph_file()
      "temp.ttl"
  """
  def temp_graph_file(), do: @temp_graph_file

  @doc """
  Lists Lib graphs in the Lib graphs library.

  ## Examples

      iex> list_graphs()
      ["tony.dot", "foo.dot", "foo1.dot"]
  """
  def list_graphs() do
    File.ls!(@graphs_dir)
    |> Enum.reject(fn e -> e == "images" end)
  end

  @doc """
  Lists Lib graphs in the Lib graph images library.

  ## Examples

      iex> list_graph_images()
      ["tony.png", "foo.png", "foo1.png"]
  """
  def list_graph_images() do
    File.ls!(@graph_images_dir)
  end

  @doc """
  Reads a Lib graph from the Lib graphs library.

  ## Examples

      iex> read_graph()
      %TestMatch.Graph{
        data: "<http:\/\/dbpedia.org\/resource\/Hello_World>\\n..."
        file: "default.ttl",
        path: "...\/test_graph\/priv\/rdf\/graphs\/default.ttl",
        type: :rdf,
        uri: "file:\/\/\/...\/test_graph\/priv\/rdf\/graphs\/default.ttl"
      }

      iex> read_graph("books.ttl")
      %TestMatch.Graph{
        data: "@prefix bibo: <http:\/\/purl.org\/ontology\/bibo\/> \\n..."
        file: "books.ttl",
        path: "...\/test_graph\/priv\/rdf\/graphs\/books.ttl",
        type: :rdf,
        uri: "file:\/\/\/...\/test_graph\/priv\/rdf\/graphs\/books.ttl"
      }
  """
  def read_graph(graph_file \\ graph_file()) do
    graphs_dir = @graphs_dir
    graph_data = File.read!(graphs_dir <> graph_file)

    TestMatch.Graph.new(graph_data, graph_file, :lib)
  end

  @doc """
  Writes a Lib graph to a file in the Lib graphs library.

  ## Examples

      iex> data |> write_graph("my.dot")
      %TestMatch.Graph{
        data: "@prefix bibo: <http:\/\/purl.org\/ontology\/bibo\/> \\n..."
        file: "my.dot",
        path: "\/test_graph\/priv\/lib\/graphs\/my.dot",
        type: :lib,
        uri: "file:\/\/\/...\/test_graph\/priv\/lib\/graphs\/my.dot"
      }

  """
  def write_graph(graph_data, graph_file \\ temp_graph_file()) do
    graphs_dir = @graphs_dir
    File.write!(graphs_dir <> graph_file, graph_data)

    TestMatch.Graph.new(graph_data, graph_file, :lib)
  end

  ##

  # TestMatch.Lib.to_dot(g) |> write_lib_graph("test1.dot")

  @doc """
  Writes a Lib graph to a file in the Lib graphs library.
  """
  def write_lib_graph(lib_graph, graph_file \\ temp_graph_file()) do
    graphs_dir = @graphs_dir

    graph_data =
      Graph.to_dot(lib_graph)
      |> case do
        {:ok, dot} -> dot
        {:error, error} -> raise error
      end

    File.write!(graphs_dir <> graph_file, graph_data)

    TestMatch.Graph.new(graph_data, graph_file, :lib)
  end

  @doc """
  Writes a graph to a `.png` file in the Lib graph images library.

  The layout tool used is selected by the `binary` argument and is one of the following atoms:

  * `:dot` − filter for drawing directed graphs
  * `:neato` − filter for drawing undirected graphs
  * `:twopi` − filter for radial layouts of graphs
  * `:circo` − filter for circular layout of graphs
  * `:fdp` − filter for drawing undirected graphs
  * `:sfdp` − filter for drawing large undirected graphs
  * `:patchwork` − filter for squarified tree maps
  * `:osage` − filter for array-based layouts
  """
  def to_png(graph, binary \\ :dot) do
    binary =
      case binary do
        :dot -> @dot_binary
        :neato -> @neato_binary
        :twopi -> @twopi_binary
        :circo -> @circo_binary
        :fdp -> @fdp_binary
        :sfdp -> @sfdp_binary
        :patchwork -> @patchwork_binary
        :osage -> @osage_binary
        _ -> @dot_binary
      end

    dot_file = @graphs_dir <> graph.file
    # png_file = Path.dirname(dot_file) <> "/images/" <> Path.basename(dot_file, ".dot") <> ".png"
    png_file = @graph_images_dir <> Path.basename(dot_file, ".dot") <> ".png"

    System.cmd(binary, ["-T", "png", dot_file, "-o", png_file])
  end

  ##

  @doc """
  Executes `cypher_query` and returns a graph.
  """
  def from_cypher(cypher_query \\ cypher_query()) do
    alias Bolt.Sips.Types.{Node, Relationship}

    g = Graph.new()

    results = TestMatch.cypher!(cypher_query)

    results
    |> Enum.reduce(
      g,
      fn result, g ->
        # match nodes
        %Node{
          id: n,
          labels: _nl,
          properties: _np
        } = result["n"]

        %Node{
          id: o,
          labels: _ol,
          properties: _op
        } = result["o"]

        # match relationship
        %Relationship{
          end: re,
          id: _r,
          properties: _ro,
          start: rs,
          type: rl
        } = result["r"]

        # build graph
        g
        |> Graph.add_vertex(
          # String.to_atom(Integer.to_string(n)), _nl
          String.to_atom(Integer.to_string(n))
        )
        |> Graph.add_vertex(
          # String.to_atom(Integer.to_string(o)), _ol
          String.to_atom(Integer.to_string(o))
        )
        |> Graph.add_edge(
          String.to_atom(Integer.to_string(rs)),
          String.to_atom(Integer.to_string(re)),
          label: String.to_atom(rl)
        )
      end
    )
  end

  @doc """
  Executes `cypher_query` and returns a graph with properties in ETS tables.
  """
  def from_cypher_with_properties(cypher_query \\ cypher_query()) do
    alias Bolt.Sips.Types.{Node, Relationship}

    g = Graph.new()

    results = TestMatch.cypher!(cypher_query)

    results
    |> Enum.reduce(
      g,
      fn result, g ->
        # match nodes
        %Node{
          id: n,
          labels: _nl,
          properties: np
        } = result["n"]

        %Node{
          id: o,
          labels: _ol,
          properties: op
        } = result["o"]

        # match relationship
        %Relationship{
          end: re,
          id: r,
          properties: rp,
          start: rs,
          type: rl
        } = result["r"]

        # store properties in ETS
        :ets.insert(@node_table, {n, np})
        :ets.insert(@node_table, {o, op})
        :ets.insert(@edge_table, {r, rs, re, rp})

        # build graph
        g
        |> Graph.add_vertex(
          # String.to_atom(Integer.to_string(n)), _nl
          String.to_atom(Integer.to_string(n))
        )
        |> Graph.add_vertex(
          # String.to_atom(Integer.to_string(o)), _ol
          String.to_atom(Integer.to_string(o))
        )
        |> Graph.add_edge(
          String.to_atom(Integer.to_string(rs)),
          String.to_atom(Integer.to_string(re)),
          label: String.to_atom(rl)
        )
      end
    )
  end

  @doc """
  Executes `sparql_query` and returns a graph.
  """
  def from_sparql(sparql_query \\ sparql_query()) do
    alias SPARQL.Query.Result

    g = Graph.new()

    results =
      case TestMatch.sparql!(sparql_query) do
        %RDF.Graph{descriptions: _descriptions} ->
          raise "! SPARQL 'CONSTRUCT', 'DESCRIBE' queries not supported"

        %Result{results: true} ->
          raise "! SPARQL 'ASK' queries not supported"

        %Result{results: results} ->
          results

        _ ->
          raise "! Unrecognized result format"
      end

    results
    |> Enum.reduce(
      g,
      fn result, g ->
        Graph.add_edge(
          g,
          String.to_atom(result["s"].value),
          String.to_atom(result["o"].value),
          label: String.to_atom(result["p"].value)
        )
      end
    )
  end

  ##

  @doc """
  Create `@node_table` and `@edge_table` ETS tables.
  """
  def create_ets_tables do
    :ets.new(@node_table, [:named_table])
    :ets.new(@edge_table, [:named_table])
  end
end
