# This example loads an RDF graph for the resource dbr:London
# into a Neo4j instance using a neosemantics stored procedure
# and then it exports the LPG graph as RDF
#
# Usage:
#
# % mix run examples/london_roundtrip.exs
# "@prefix neovoc: <neo4j://vocabulary#> .
#
# <http://dbpedia.org/resource/London> <http://dbpedia.org/ontology/PopulatedPlace/areaTotal>
    "1572.0";
#  <http://dbpedia.org/ontology/PopulatedPlace/populationDensity> "5518.0";
#  <http://dbpedia.org/ontology/abstract> "Ло́ндон (англ. London [ˈlʌndən] (инф.)) — столица и крупнейший город Соединённого Королевства Великобритании и Северной Ирландии. Административно образует регион Англии Большой Лондон, разделённый на 33 самоуправляемых района. Население составляет 8,6 млн человек (2015 год), второй по величине город Европы и крупнейший в Евросоюзе. Образует агломерацию «Большой Лондон» и более обширный метрополитенский район. Расположен на юго-востоке острова Великобритания, на равнине Лондонского бассейна, в устье Темзы вблизи Северного моря. Главный политический, экономический и культурный центр Великобритании. Экономика города занимает пятую часть экономики страны. Относится к глобальным городам высшего ранга, ведущим мировым финансовым центрам. Исторический центр, образованный районами Вестминстер и Сити, сложился в Викторианскую эпоху. Среди единичных построек, уцелевших после пожара 1666 года, — средневековая крепость Тауэр. Основан около 43 года под названием Лондиниум римлянами вскоре после их вторжения в Британию. В I—III веках — столица римской Британии, с XI—XII веков — Англии, с 1707 года — Великобритании, с XVI по XX век — Британской империи. С 1825 по 1925 год был крупнейшим городом мира.";
#  <http://dbpedia.org/ontology/leaderTitle> "UK Parliament";
#  <http://dbpedia.org/ontology/populationDensity> 5.518E3;
#  <http://dbpedia.org/ontology/utcOffset> "±00:00UTC";
#  <http://dbpedia.org/ontology/wikiPageID> "17867"^^<http://www.w3.org/2001/XMLSchema#long>;" <> ...

import TestGraph

# subject resource to query (dbr:London)
resource = "http://dbpedia.org/resource/London"

# # read (and save) graph from DBpedia by querying
# import_rdf_from_query("london.rq")

# read from saved graph
import_rdf_from_graph("london.ttl")

#
IO.puts export_rdf_by_uri(resource).data
