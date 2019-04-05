# This example queries DBpedia for resource dbr:London (first 100 triples)
# and loads these to a Neo4j instance
#
# Usage:
#
# % mix run examples/london100.exs
# terminationStatus = OK
# triplesLoaded = 100
#
# [%{"nodes" => 33, "paths" => 63, "relationships" => 32}]

import TestGraph.RDF.SPARQL.Client, only: [triples_by_uri: 2]

# subject resource to query (dbr:London)
resource = "http://dbpedia.org/resource/London"

# Bolt connection
conn = Bolt.Sips.conn()

# return TestGraph.Graph struct for 100 triples (saved to "london100.ttl")
graph = (
  triples_by_uri(resource, 100)
  |> RDF.Turtle.write_string!
  |> TestGraph.RDF.write_graph("london100.ttl")
)

# use NeoSemantics.import_turtle/2 to import turtle to Neo4j
[ map ] = NeoSemantics.import_turtle!(conn, graph.uri)

IO.puts "terminationStatus = " <> map["terminationStatus"]
IO.puts "triplesLoaded = " <> Integer.to_string(map["triplesLoaded"])
IO.puts ""

# test Neo4j database
IO.inspect TestGraph.LPG.Cypher.Client.test()
