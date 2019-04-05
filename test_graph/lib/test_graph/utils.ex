defmodule TestGraph.Utils do
  @moduledoc """
  Module providing helper functions.
  """

  @priv_dir "#{:code.priv_dir(:test_graph)}"

  @graphgists_dir @priv_dir <> "/lpg/graphgists/"
  @test_graphgist_file "template.adoc"

  @doc """
  Lists toplevel module's functions.

  ## Examples

      iex> help
      [
        export_rdf_by_id: 1,
        export_rdf_by_id: 2,
        export_rdf_by_query: 2,
        export_rdf_by_uri: 1,
        export_rdf_by_uri: 2,
        import_rdf_from_graph: 0,
        import_rdf_from_graph: 1,
        import_rdf_from_query: 0,
        import_rdf_from_query: 1
      ]
      :ok
  """
  def help() do
    # inspect(TestGraph.__info__(:functions), limit: :infinity)
    IO.puts inspect(TestGraph.__info__(:functions), limit: :infinity, pretty: true)
  end

  @doc """
  Lists named module's functions.

  ## Examples

      iex> help NeoSemantics
      [
        import_jsonld: 2,
        import_jsonld!: 2,
        import_ntriples: 2,
        import_ntriples!: 2,
        import_rdf: 3,
        import_rdf!: 3,
        import_rdfxml: 2,
        import_rdfxml!: 2,
        import_trig: 2,
        import_trig!: 2,
        import_turtle: 2,
        import_turtle!: 2,
        lite_onto_import: 3,
        lite_onto_import!: 3,
        preview_rdf: 3,
        preview_rdf!: 3,
        preview_rdf_snippet: 3,
        preview_rdf_snippet!: 3,
        stream_rdf: 3,
        stream_rdf!: 3
      ]
      :ok
  """
  def help(module) do
    # inspect(module.__info__(:functions), limit: :infinity)
    IO.puts inspect(module.__info__(:functions), limit: :infinity, pretty: true)
  end

  ## graphgists

  @doc """
  Reads a graphgist from the graphgists library.

  ## Examples

      iex> read_graphgist("template.adoc")
      "= REPLACEME: TITLE OF YOUR GRAPHGIST\\n:neo4j-version: 2.3.0\\n:author:" <> ...

  """
  def read_graphgist(graphgist_file \\ @test_graphgist_file) do
    File.read!(@graphgists_dir <> graphgist_file)
  end

  @doc """
  Parses a graphgist to return a Cypher graph.

  ## Examples

      iex> parse(read_graphgist())
      "CREATE\\n  (a:Person {name: 'Alice'}),\\n  (b:Person {name: 'Bob'}),\\n" <> ...

  """
  def parse(graphgist) do
    Regex.run(
      ~r/\/setup\n(\/\/hide\n)*(\/\/output\n)*\[source,\s*cypher\]\n\-\-\-\-.*\n((.|\n)*)\-\-\-\-.*\n/Um,
      graphgist
    )
    |> case do
      [_, cypher, _] -> cypher       # //hide\n
      [_, _, cypher, _] -> cypher    # //hide\n//output]\n
      [_, _, _, cypher, _] -> cypher
      _ -> ""
    end
  end


end
