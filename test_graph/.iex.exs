import Bolt.Sips, only: [config: 0, conn: 0]
import TestGraph
import TestGraph.Utils

alias TestGraph.Graph
alias TestGraph.LPG.Cypher
alias TestGraph.RDF.SPARQL
# import Cypher.Client
 import SPARQL.Client

Application.put_env(:test_graph,
  :sparql_query, TestGraph.RDF.SPARQL.Client.default_sparql_query)
Application.put_env(:test_graph,
  :sparql_service, TestGraph.RDF.SPARQL.Client.default_sparql_service)
