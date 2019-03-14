use Mix.Config

config :bolt_sips, Bolt,
  basic_auth: [username: "test", password: "neo4jtest"],
  url: "bolt://52.91.116.38:36555",
  pool_size: 5,
  max_overflow: 1
