# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# HTTP client
config :tesla,
  adapter: Tesla.Adapter.Hackney

# Neo4j database access
config :bolt_sips, Bolt,
  url: "bolt://neo4j:neo4jtest@localhost:7687"

config :test_graph,
  neo4j_service: "http://neo4j:neo4jtest@localhost:7474"

# RDF database access
config :test_graph,
  :sparql, [ :sparql_dbpedia, :sparql_local, :sparql_wikidata ]

config :test_graph, :sparql_dbpedia,
  url: "http://dbpedia.org/sparql"

config :test_graph, :sparql_local,
  url: "http://localhost:7200/repositories/test-graph"

config :test_graph, :sparql_wikidata,
  url: "https://query.wikidata.org/bigdata/namespace/wdq/sparql"


# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :test_graph, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:test_graph, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
