defmodule TestQuery.Client do
  @moduledoc """
  TestQuery.Client module
  """

  @endpoint "http://dbpedia.org/sparql"
  @entity_uri "http://dbpedia.org/resource/Hello_World"

  @query """
select *
where {
  bind (<#{@entity_uri}> as ?s)
  ?s ?p ?o .
  filter (isLiteral(?o) && langMatches(lang(?o), "en"))
}
"""

  @query_dir "#{:code.priv_dir(:test_query)}/queries/"

  @doc """
  hello/0 - Queries remote RDF datastore with default SPARQL query
            and prints out result set
  """
  def hello() do

    {:ok, results} = SPARQL.Client.query(@query, @endpoint)
    IO.inspect results.results
    results.results
    |> Enum.each(fn t -> IO.puts t["o"].value end)
  end

end
