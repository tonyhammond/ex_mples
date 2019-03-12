use Mix.Config

config :bolt_sips, Bolt,
  basic_auth: [username: "neo4j", password: "neo4jtest"],
  url: "http://localhost:7687",
  pool_size: 5,
  max_overflow: 1


