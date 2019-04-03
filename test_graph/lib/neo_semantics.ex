defmodule NeoSemantics do
  @moduledoc """
  Module providing simple wrapper functions for the [`neosemantics`](https://github.com/jbarrasa/neosemantics) library.

  The `neosemantics` library is authored by
  [Jesús Barrasa](https://twitter.com/barrasadv)
  (and see [https://jbarrasa.com](https://jbarrasa.com) for example usage posts).

  Note that the wrapper functions use snake case which is more usual in Elixir, e.g.
  `NeoSemantics.import_rdf/3` for `semantics.importRDF`. Also there is an additional
  first argument for the `bolt_sips` connection. And in the examples this is shown being
  piped in to emphasize that this is an additional argument.

  Note also that the wrapper functions come in two flavours: with and without a trailing bang (`!`) character.
  The simple form returns a success or failure tuple which can be used in pattern matching,
  whereas the marked form returns a plain value or raises an exception. When a positive
  outcome is expected the marked form may be easier to use. (See Elixir [naming conventions](https://github.com/elixir-lang/elixir/blob/master/lib/elixir/pages/Naming%20Conventions.md#trailing-bang-foo) for more info.)

  TODO - Valid formats: Turtle, N-Triples, JSON-LD, TriG, RDF/XML.

  TODO - Add parameter maps for function calls which give some fine control. For now, defaults are fine.

  ## Examples

      iex> uri = TestGraph.RDF.read_graph().uri
      "file:///.../priv/rdf/graphs/default.ttl"
      iex> fmt = "Turtle"
      "http//purl.org/dc/elements/1.1/" => "dc",

      # simple form - import_rdf/3
      iex> {:ok, resp} = (conn |> NeoSemantics.import_rdf(uri, fmt))
      {:ok,
       [
         %{
           "extraInfo" => "",
           "namespaces" => %{
             "http://purl.org/dc/elements/1.1/" => "dc",
             "http://purl.org/dc/terms/" => "dct",
             "http://purl.org/ontology/bibo/" => "ns0",
             "http://schema.org/" => "sch",
             "http://www.w3.org/1999/02/22-rdf-syntax-ns#" => "rdf",
             "http://www.w3.org/2000/01/rdf-schema#" => "rdfs",
             "http://www.w3.org/2002/07/owl#" => "owl",
             "http://www.w3.org/2004/02/skos/core#" => "skos"
           },
           "terminationStatus" => "OK",
           "triplesLoaded" => 8
         }
       ]}
      iex> resp
      [
         %{
           "extraInfo" => "",
           "namespaces" => %{
             "http://purl.org/dc/elements/1.1/" => "dc",
             "http://purl.org/dc/terms/" => "dct",
             "http://purl.org/ontology/bibo/" => "ns0",
             "http://schema.org/" => "sch",
             "http://www.w3.org/1999/02/22-rdf-syntax-ns#" => "rdf",
             "http://www.w3.org/2000/01/rdf-schema#" => "rdfs",
             "http://www.w3.org/2002/07/owl#" => "owl",
             "http://www.w3.org/2004/02/skos/core#" => "skos"
           },
           "terminationStatus" => "OK",
           "triplesLoaded" => 8
         }
      ]
      iex> conn |> Cypher.Client.test()
      [%{"nodes" => 6, "paths" => 8, "relationships" => 4}]


      # marked form - import_rdf!/3
      iex> conn |> NeoSemantics.import_rdf!(uri, fmt)
      [
        %{
          "extraInfo" => "",
          "namespaces" => %{
            "http://purl.org/dc/elements/1.1/" => "dc",
            "http://purl.org/dc/terms/" => "dct",
            "http://purl.org/ontology/bibo/" => "ns0",
            "http://schema.org/" => "sch",
            "http://www.w3.org/1999/02/22-rdf-syntax-ns#" => "rdf",
            "http://www.w3.org/2000/01/rdf-schema#" => "rdfs",
            "http://www.w3.org/2002/07/owl#" => "owl",
            "http://www.w3.org/2004/02/skos/core#" => "skos"
          },
          "terminationStatus" => "OK",
          "triplesLoaded" => 8
        }
      ]
      iex> conn |> Cypher.Client.test()
      [%{"nodes" => 6, "paths" => 8, "relationships" => 4}]

  """
  ##

  @doc """
  Imports into Neo4j all the triples in the data set according to the mapping defined in [this post](https://jesusbarrasa.wordpress.com/2016/06/07/importing-rdf-data-into-neo4j/).

  Sends the Cypher query `call semantics.importRDF(...)` to the server and returns `{:ok, Bolt.Sips.Response}` or `{:error, error}` otherwise
  """
  def import_rdf(conn, uri, format) do
    cypher = "call semantics.importRDF(\"" <> uri <> "\", \"" <> format <> "\", {})"
    Bolt.Sips.query(conn, cypher)
  end

  @doc """
  The same as `import_rdf/3` but raises a `Bolt.Sips.Exception` if it fails. Returns the server response otherwise.
  """
  def import_rdf!(conn, uri, format) do
    cypher = "call semantics.importRDF(\"" <> uri <> "\", \"" <> format <> "\", {})"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Parses some RDF and produces a preview in Neo4j browser.

  Sends the Cypher query `call semantics.previewRDF(...)` to the server and returns `{:ok, Bolt.Sips.Response}` or `{:error, error}` otherwise
  """
  def preview_rdf(conn, uri, format) do
    cypher = "call semantics.previewRDF(\"" <> uri <> "\", \"" <> format <> "\", {})"
    Bolt.Sips.query(conn, cypher)
  end

  @doc """
  The same as `preview_rdf/3` but raises a `Bolt.Sips.Exception` if it fails. Returns the server response otherwise.
  """
  def preview_rdf!(conn, uri, format) do
    cypher = "call semantics.previewRDF(\"" <> uri <> "\", \"" <> format <> "\", {})"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Identical to previewRDF but takes an RDF snippet instead of the url of the dataset.

  Sends the Cypher query `call semantics.previewRDFSnippet(...)` to the server and returns `{:ok, Bolt.Sips.Response}` or `{:error, error}` otherwise
  """
  def preview_rdf_snippet(conn, uri, format) do
    cypher = "call semantics.previewRDFSnippet(\"" <> uri <> "\", \"" <> format <> "\", {})"
    Bolt.Sips.query(conn, cypher)
  end

  @doc """
  The same as `preview_rdf_snippet/3` but raises a `Bolt.Sips.Exception` if it fails. Returns the server response otherwise.
  """
  def preview_rdf_snippet!(conn, uri, format) do
    cypher = "call semantics.previewRDFSnippet(\"" <> uri <> "\", \"" <> format <> "\", {})"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Parses some RDF and streams the triples as records of the form subject, predicate, object plus three additional fields.

  Sends the Cypher query `call semantics.streamRDF(...)` to the server and returns `{:ok, Bolt.Sips.Response}` or `{:error, error}` otherwise
  """
  def stream_rdf(conn, uri, format) do
    cypher = "call semantics.streamRDF(\"" <> uri <> "\", \"" <> format <> "\", {})"
    Bolt.Sips.query(conn, cypher)
  end

  @doc """
  The same as `stream_rdf/3` but raises a `Bolt.Sips.Exception` if it fails. Returns the server response otherwise.
  """
  def stream_rdf!(conn, uri, format) do
    cypher = "call semantics.streamRDF(\"" <> uri <> "\", \"" <> format <> "\", {})"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Imports the basic elements of an OWL or RDFS ontology, i.e. Classes, Properties, Domains, Ranges.

  Sends the Cypher query `call semantics.liteOntoImport(...)` to the server and returns `{:ok, Bolt.Sips.Response}` or `{:error, error}` otherwise
  """
  def lite_onto_import(conn, uri, format) do
    cypher = "call semantics.liteOntoImport(\"" <> uri <> "\", \"" <> format <> "\")"
    Bolt.Sips.query(conn, cypher)
  end

  @doc """
  The same as `lite_onto_import/3` but raises a `Bolt.Sips.Exception` if it fails. Returns the server response otherwise.
  """
  def lite_onto_import!(conn, uri, format) do
    cypher = "call semantics.liteOntoImport(\"" <> uri <> "\", \"" <> format <> "\")"
    Bolt.Sips.query!(conn, cypher)
  end

end
