# This example loads an RDF graph for the resource dbr:London
# into a Neo4j instance using a neosemantics stored procedure
# and then it exports the LPG graph as RDF
#
# Usage:
#
# % mix run examples/london_roundtrip.exs
# @prefix neovoc: <neo4j://vocabulary#> .
#
# <http://dbpedia.org/resource/London> <http://dbpedia.org/ontology/PopulatedPlace/areaTotal> "1572.0";
#   <http://dbpedia.org/ontology/PopulatedPlace/populationDensity> "5518.0";
#   <http://dbpedia.org/ontology/abstract> "Ло́ндон (англ. London [ˈlʌndən] (инф.)) — столица и крупнейший город Соединённого Королевства Великобритании и Северной Ирландии. ...";
#   <http://dbpedia.org/ontology/leaderTitle> "UK Parliament";
#   <http://dbpedia.org/ontology/populationDensity> 5.518E3;
#   <http://dbpedia.org/ontology/utcOffset> "±00:00UTC";
# ...
#   <http://xmlns.com/foaf/0.1/name> "London" .

import TestGraph

# subject resource to query (dbr:London)
resource = "http://dbpedia.org/resource/London"

# # read (and save) graph from DBpedia by querying
# import_rdf_from_query("london.rq")

# read from saved graph
import_rdf_from_graph("london.ttl")

# print out exported graph
IO.puts export_rdf_by_uri(resource).data
