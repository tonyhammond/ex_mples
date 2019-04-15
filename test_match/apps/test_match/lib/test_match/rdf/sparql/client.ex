defmodule TestMatch.RDF.SPARQL.Client do
  @moduledoc """
  Module providing simple wrapper functions for the `SPARQL.Client` module.
  """
  import TestMatch.RDF
  # import SPARQL.Client

  @query_file_triples "triples.rq"
  @query_file_triples_by_uri "triples_by_uri.rq"

  ## Accessors for env variables

  @doc """
  Returns default SPARQL endpoint.

  ## Examples

      iex> sparql_endpoint()
      "http://localhost:7200/repositories/test-graph"
  """
  def sparql_endpoint, do: Application.get_env(:test_match, :sparql_endpoint)

  @doc """
  Sets default SPARQL endpoint.

  ## Examples

      iex> sparql_endpoint(:sparql_dbpedia)
      "http://dbpedia.org/sparql"
  """
  def sparql_endpoint(sparql_service) do
     Application.put_env(:test_match,
       :sparql_endpoint, _sparql_endpoint_url(sparql_service))
     Application.get_env(:test_match, :sparql_endpoint)
  end

  defp _sparql_endpoint_url(sparql_service) do
    [url: url] = Application.get_env(:test_match, sparql_service, :url)
    url
  end

  @doc """
  Returns SPARQL services.

  ## Examples

      iex> list_sparql_services()
      [:sparql_dbpedia, :sparql_local, :sparql_wikidata]
  """
  def sparql_services, do: Application.get_env(:test_match, :sparql)

  @doc """
  Sets local SPARQL endpoint.

  ## Examples

      iex> local_sparql_endpoint()
      "http://localhost:7200/repositories/test-graph"
  """
  def local_sparql_endpoint, do: sparql_endpoint(:sparql_local)

  @doc """
  Sets DBpedia SPARQL endpoint.

  ## Examples

      iex> dbpedia_sparql_endpoint()
      "http://dbpedia.org/sparql"
  """
  def dbpedia_sparql_endpoint, do: sparql_endpoint(:sparql_dbpedia)

  @doc """
  Sets Wikidata SPARQL endpoint.

  ## Examples

      iex> wikidata_sparql_endpoint()
      "https://query.wikidata.org/bigdata/namespace/wdq/sparql"
  """
  def wikidata_sparql_endpoint, do: sparql_endpoint(:sparql_wikidata)

  @doc """
  Returns default SPARQL query.

  ## Examples

      iex> sparql_query()
      "construct\\n{ ?s ?p ?o }\\nwhere {\\n  ?s ?p ?o\\n} limit 1\\n"
  """
  def sparql_query(), do: read_query().data

  @doc """
  Returns saved SPARQL query.

  ## Examples

      iex> list_rdf_queries
      ["cypher.rq", "london.rq", "elixir.rq", "default.rq", "neo4j.rq",
       "triples_by_uri.rq", "triples.rq", "hello.rq"]

      iex> sparql_query("hello.rq")
      "construct\\n{ ?s ?p ?o }\\nwhere {\\n  bind (<http://dbpedia.org/resource/Hello_World> as ?s)\\n  ?s ?p ?o\\n  filter (isLiteral(?o) && langMatches(lang(?o), \\"en\\"))\\n}\\n"
  """
  def sparql_query(query_file), do: read_query(query_file).data

  @doc """
  Queries a SPARQL endpoint with a SPARQL query.

  ## Examples

      iex> sparql_endpoint
      "http://localhost:7200/repositories/test-graph"

      iex> sparql_endpoint(:sparql_dbpedia)
      "http://dbpedia.org/sparql"

      iex> read_rdf_query("hello.rq").data |>  SPARQL_Client.rquery()
      {:ok, #RDF.Graph{name: nil
            ~I<http://dbpedia.org/resource/Hello_World>
                ~I<http://www.w3.org/2000/01/rdf-schema#label>
                    ~L"Hello World"en}}
  """
  def rquery(query \\ sparql_query(), endpoint \\ sparql_endpoint()) do
    SPARQL.Client.query(query, endpoint)
  end

  @doc """
  The same as `rquery` but raises a runtime error if it fails.

  ## Examples

      iex> sparql_endpoint
      "http://dbpedia.org/sparql"

      iex> read_rdf_query("hello.rq").data |>  SPARQL_Client.rquery()
      #RDF.Graph{name: nil
           ~I<http://dbpedia.org/resource/Hello_World>
               ~I<http://www.w3.org/2000/01/rdf-schema#label>
                   ~L"Hello World"en}
  """
  def rquery!(query \\ sparql_query(), endpoint \\ sparql_endpoint()) do
    SPARQL.Client.query(query, endpoint)
    |>
    case do
      {:ok, resp} -> resp
      {:error, error} -> raise error
    end
  end

  ##

  def triples(limit \\ nil) do
    case limit do
      nil -> rquery!(read_query(@query_file_triples).data)
      _ ->
        limit = Integer.to_string(limit)
        rquery!(read_query(@query_file_triples).data <> " limit " <> limit)
    end
  end

  def triples_by_uri(uri, limit \\ nil) do
    q = read_query(@query_file_triples_by_uri).data
    query = String.replace(q, "_uri", uri)
    case limit do
      nil -> rquery!(query)
      _ ->
        limit = Integer.to_string(limit)
        rquery!(query <> " limit " <> limit)
    end
  end

end
