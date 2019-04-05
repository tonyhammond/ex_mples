import TestGraph.RDF.SPARQL.Client, only: [triples_by_uri: 2]

# Bolt connection
conn = Bolt.Sips.conn()

# return TestGraph.Graph struct for 100 triples (saved to "london100.ttl")
# SPARQL query is for dbr:London
graph = (triples_by_uri("http://dbpedia.org/resource/London", 100)
|> RDF.Turtle.write_string!
|> TestGraph.RDF.write_graph("london100.ttl"))

# use NeoSemantics.import_turtle/2 to import to Neo4j
IO.inspect NeoSemantics.import_turtle!(conn, graph.uri)

# test Neo4j database
IO.inspect TestGraph.LPG.Cypher.Client.test()
