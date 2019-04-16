# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.

use Mix.Config

# HTTP client
config :tesla,
  adapter: Tesla.Adapter.Hackney

# LPG database access
config :bolt_sips, Bolt, url: "bolt://neo4j:neo4jtest@localhost:7687"

# config :test_match,
#   neo4j_service: "http://neo4j:neo4jtest@localhost:7474"

# RDF database access
config :test_match,
  sparql: [:sparql_dbpedia, :sparql_local, :sparql_wikidata]

config :test_match, :sparql_dbpedia, url: "http://dbpedia.org/sparql"

config :test_match, :sparql_local, url: "http://localhost:7200/repositories/test-graph"

config :test_match, :sparql_wikidata,
  url: "https://query.wikidata.org/bigdata/namespace/wdq/sparql"

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
