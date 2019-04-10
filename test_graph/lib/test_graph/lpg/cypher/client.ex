defmodule TestGraph.LPG.Cypher.Client do
  @moduledoc """
  Module providing a simple library for querying LPG models in a Neo4j instance via Cypher.
  """

  import TestGraph.LPG

  @query_file_nodes "nodes.cypher"
  @query_file_node_by_id "node_by_id.cypher"
  @query_file_node_ids "node_ids.cypher"
  @query_file_relationships "relationships.cypher"
  @query_file_relationship_by_id "relationship_by_id.cypher"
  @query_file_relationship_ids "relationship_ids.cypher"
  @query_file_nodes_and_relationships "nodes_and_relationships.cypher"
  @query_file_paths "paths.cypher"

  @query_file_node1 "node1.cypher"
  @query read_query(@query_file_node1).data
  # @service Bolt.Sips.conn()

  @doc """
  Queries default Bolt connection with default Cypher query.

  ## Examples

      iex> Cypher.Client.rquery()
      {:ok,
       [
         %{
           "n" => %Bolt.Sips.Types.Node{
             id: 919,
             labels: ["Resource"],
             properties: %{
               "rdfs__label" => "Hello World",
               "uri" => "http://dbpedia.org/resource/Hello_World"
             }
           }
         }
       ]}
  """
  def rquery() do
    Bolt.Sips.query(Bolt.Sips.conn(), @query)
  end

  @doc """
  The same as `rquery/0` but raises a runtime error if it fails.

  ## Examples

      iex> Cypher.Client.rquery!()
      [
        %{
          "n" => %Bolt.Sips.Types.Node{
            id: 919,
            labels: ["Resource"],
            properties: %{
              "rdfs__label" => "Hello World",
              "uri" => "http://dbpedia.org/resource/Hello_World"
            }
          }
        }
      ]
  """
  def rquery!() do
    Bolt.Sips.query!(Bolt.Sips.conn(), @query)
  end

  @doc """
  Queries default Bolt connection with user Cypher query.

  ## Examples

      iex> Cypher.Client.rquery("match (n) return n limit 1")
      {:ok,
       [
         %{
           "n" => %Bolt.Sips.Types.Node{
             id: 919,
             labels: ["Resource"],
             properties: %{
               "rdfs__label" => "Hello World",
               "uri" => "http://dbpedia.org/resource/Hello_World"
             }
           }
         }
       ]}
  """
  def rquery(query) do
    Bolt.Sips.query(Bolt.Sips.conn(), query)
  end

  @doc """
  The same as `rquery/1` but raises a runtime error if it fails.

  ## Examples

      iex> Cypher.Client.rquery!("match (n) return n limit 1")
      [
        %{
          "n" => %Bolt.Sips.Types.Node{
            id: 919,
            labels: ["Resource"],
            properties: %{
              "rdfs__label" => "Hello World",
              "uri" => "http://dbpedia.org/resource/Hello_World"
            }
          }
        }
      ]
  """
  def rquery!(query) do
    Bolt.Sips.query!(Bolt.Sips.conn(), query)
  end

  @doc """
  Queries database for one node.
  """
  def node1(), do: nodes(1)

  @doc """
  Queries database for `limit` number of nodes. If no `limit` is given then all nodes are retuned.

  ## Examples

      iex> Cypher.Client.nodes(2)
      [
        %{
          "n" => %Bolt.Sips.Types.Node{
            id: 311,
            labels: ["Book"],
            properties: %{}
          }
        },
        %{
          "n" => %Bolt.Sips.Types.Node{
            id: 312,
            labels: ["Book"],
            properties: %{}
          }
        }
      ]
  """
  def nodes(limit \\ nil) do
    case limit do
      nil -> rquery!(read_query(@query_file_nodes).data)
      _ ->
        limit = Integer.to_string(limit)
        rquery!(read_query(@query_file_nodes).data <> " limit " <> limit)
    end
  end

  @doc """
  Queries database for node by `id`.

  ## Examples

      iex> Cypher.Client.node_by_id(311)
      [
        %{
          "n" => %Bolt.Sips.Types.Node{
            id: 311,
            labels: ["Book"],
            properties: %{}
          }
        },
      ]
  """
  def node_by_id(id) do
    q = read_query(@query_file_node_by_id).data
    query = String.replace(q, "_id", Integer.to_string(id))
    [ node ] = rquery!(query)
    node
  end

  @doc """
  Queries database for one node ID.
  """
  def node_id1(), do: node_ids(1)

  @doc """
  Queries database for `limit` number of node IDs. If no `limit` is given then all node IDs are retuned.

  ## Examples

      iex> Cypher.Client.node_ids()
      [
        %{"id(n)" => 1804},
        %{"id(n)" => 1805},
        %{"id(n)" => 1806},
        %{"id(n)" => 1807},
        %{"id(n)" => 6277}
      ]
  """
  def node_ids(limit \\ nil) do
    case limit do
      nil -> rquery!(read_query(@query_file_node_ids).data)
      _ ->
        limit = Integer.to_string(limit)
        rquery!(read_query(@query_file_node_ids).data <> " limit " <> limit)
    end
  end

  @doc """
  Queries database for one relationship.
  """
  def relationship1(), do: relationships(1)

  @doc """
  Queries database for relationship by `id`.

  ## Examples

      iex> Cypher.Client.relationship_by_id(9265)
      [
        %{
          "r" => %Bolt.Sips.Types.Relationship{
            end: 1786,
            id: 9265,
            properties: %{},
            start: 1783,
            type: "ns0__license"
          }
        }
      ]
  """
  def relationship_by_id(id) do
    q = read_query(@query_file_relationship_by_id).data
    query = String.replace(q, "_id", Integer.to_string(id))
    rquery!(query)
  end

  @doc """
  Queries database for one relationship ID.
  """
  def relationship_id1(), do: relationship_ids(1)

  @doc """
  Queries database for `limit` number of relationship IDs. If no `limit` is given then all relationship IDs are retuned.

  ## Examples

      iex> Cypher.Client.relationship_ids()
      [
        %{"id(n)" => 1804},
        %{"id(n)" => 1805},
        %{"id(n)" => 1806},
        %{"id(n)" => 1807},
        %{"id(n)" => 6277}
      ]
  """
  def relationship_ids(limit \\ nil) do
    case limit do
      nil -> rquery!(read_query(@query_file_relationship_ids).data)
      _ ->
        limit = Integer.to_string(limit)
        rquery!(read_query(@query_file_relationship_ids).data <> " limit " <> limit)
    end
  end

  @doc """
  Queries database for `limit` number of relationships. If no `limit` is given then all relationships are retuned.

  ## Examples

      iex> Cypher.Client.relationships()
      [
        %{
          "r" => %Bolt.Sips.Types.Relationship{
            end: 1548,
            id: 1689,
            properties: %{"role" => "second author"},
            start: 1546,
            type: "AUTHORED_BY"
          }
        },
        ...
      ]
  """
  def relationships(limit \\ nil) do
    case limit do
      nil -> rquery!(read_query(@query_file_relationships).data)
      _ ->
        limit = Integer.to_string(limit)
        rquery!(read_query(@query_file_relationships).data <> " limit " <> limit)
    end
  end

  @doc """
  Queries database for one node and relationships.
  """
  def node1_and_relationships(), do: nodes_and_relationships(1)

  @doc """
  Queries database for `limit` number of nodes and relationships. If no `limit` is given then all nodes and relationships are retuned.

  ## Examples

      iex> Cypher.Client.nodes_and_relationships()
      [
        %{
          "n" => %Bolt.Sips.Types.Node{
            id: 1546,
            labels: ["Book"],
            properties: %{
              "date" => "2018-03-14",
              "format" => "Paper",
              "iri" => "urn:isbn:978-1-68050-252-7",
              "title" => "Adopting Elixir"
            }
          },
          "r" => %Bolt.Sips.Types.Relationship{
            end: 1548,
            id: 1689,
            properties: %{"role" => "second author"},
            start: 1546,
            type: "AUTHORED_BY"
          }
        },
        ...
      ]
  """
  def nodes_and_relationships(limit \\ nil) do
    case limit do
      nil -> rquery!(read_query(@query_file_nodes_and_relationships).data)
      _ ->
        limit = Integer.to_string(limit)
        rquery!(read_query(@query_file_nodes_and_relationships).data <> " limit " <> limit)
    end
  end

  @doc """
  Queries database for one path.
  """
  def path1(), do: paths(1)

  @doc """
  Queries database for `limit` number of paths. If no `limit` is given then all paths are retuned.

  ## Examples

      iex> Cypher.Client.paths()
      [
        %{
          "p" => %Bolt.Sips.Types.Path{
            nodes: [
              %Bolt.Sips.Types.Node{
                id: 1548,
                labels: ["Author"],
                properties: %{"iri" => "https://twitter.com/josevalim"}
              },
              %Bolt.Sips.Types.Node{
                id: 1546,
                labels: ["Book"],
                properties: %{
                  "date" => "2018-03-14",
                  "format" => "Paper",
                  "iri" => "urn:isbn:978-1-68050-252-7",
                  "title" => "Adopting Elixir"
                }
              }
            ],
            relationships: [
              %Bolt.Sips.Types.UnboundRelationship{
                end: nil,
                id: 1689,
                properties: %{"role" => "second author"},
                start: nil,
                type: "AUTHORED_BY"
              }
            ],
            sequence: [-1, 1]
          }
        },
        ...

      ]
  """
  def paths(limit \\ nil) do
    case limit do
      nil -> rquery!(read_query(@query_file_paths).data)
      _ ->
        limit = Integer.to_string(limit)
        rquery!(read_query(@query_file_paths).data <> " limit " <> limit)
    end
  end

  ## database
  @doc """
  Opens up a Bolt database connection with the app config.

  ## Examples

      iex> Cypher.Client.init()
      [
        socket: Bolt.Sips.Socket,
        port: 7687,
        hostname: 'localhost',
        retry_linear_backoff: [delay: 150, factor: 2, tries: 3],
        with_etls: false,
        ssl: false,
        timeout: 15000,
        max_overflow: 2,
        pool_size: 5,
        url: "bolt://localhost:7687",
        basic_auth: [username: "neo4j", password: "neo4jtest"]
      ]
  """
  def init() do
    Application.get_env(:bolt_sips, Bolt)
    |> Bolt.Sips.start_link()

    Bolt.Sips.config()
  end

  @doc """
  Deletes all nodes and relationships in database.

  ## Examples

      iex> Cypher.Client.clear()
      %{stats: %{"nodes-deleted" => 171, "relationships-deleted" => 253}, type: "w"}

  """
  def clear() do
    Bolt.Sips.query!(
      Bolt.Sips.conn(),
      """
      match (n) optional match (n)-[r]-() delete n,r
      """
    )
  end

  @doc """
  Dumps all nodes and relationships in database.

  ## Examples

      iex(3)> Cypher.Client.dump("nobelprizes.cypher")
      [
        %{
          "batchSize" => 20000,
          "batches" => 4,
          "cleanupStatements" => nil,
          "cypherStatements" => nil,
          "file" => ".../test_graph/priv/lpg/graphs/nobelprizes.cypher",
          "format" => "cypher",
          "nodeStatements" => nil,
          "nodes" => 21027,
          "properties" => 49184,
          "relationshipStatements" => nil,
          "relationships" => 43267,
          "rows" => 64294,
          "schemaStatements" => nil,
          "source" => "database: nodes(21027), rels(43267)",
          "time" => 949
        }
      ]
  """
  def dump(graph_file) do
    graphs_dir = graphs_dir()
    query = "call apoc.export.cypher.all('" <> graphs_dir <> graph_file <> "',{format:'plain'})"
    Bolt.Sips.query!(
      Bolt.Sips.conn(),
      query
    )
  end

  @doc """
  Dumps all nodes and relationships in database.

  ## Examples

      iex(3)> cypher_dump("match (n) return n limit 3", "limit3.cypher")
      [
        %{
          "batchSize" => 20000,
          "batches" => 1,
          "cleanupStatements" => nil,
          "cypherStatements" => nil,
          "file" => ".../test_graph/priv/lpg/graphs/limit3.cypher",
          "format" => "cypher",
          "nodeStatements" => nil,
          "nodes" => 3,
          "properties" => 3,
          "relationshipStatements" => nil,
          "relationships" => 0,
          "rows" => 3,
          "schemaStatements" => nil,
          "source" => "statement: nodes(3), rels(0)",
          "time" => 1
        }
      ]
  """
  def dump(query_file, graph_file) do
    graphs_dir = graphs_dir()
    query = "call apoc.export.cypher.query('" <> query_file <> "','" <> graphs_dir <> graph_file <> "',{format:'plain'})"
    Bolt.Sips.query!(
      Bolt.Sips.conn(),
      query
    )
  end

  @doc """
  Deletes all nodes and relationships in database.

  ## Examples

      iex> Cypher.Client.reset()
      %{stats: %{"nodes-deleted" => 171, "relationships-deleted" => 253}, type: "w"}

  """
  def reset() do
    Bolt.Sips.query!(
      Bolt.Sips.conn(),
      """
      match (n) optional match (n)-[r]-() delete n,r
      """
    )
  end

  @doc """
  Counts nodes, relationships and paths in database.

  ## Examples

      iex> Cypher.Client.test()
      [%{"nodes" => 171, "paths" => 506, "relationships" => 253}]

  """
  def test() do
    Bolt.Sips.query!(
      Bolt.Sips.conn(),
      """
      match (n) optional match p = (n)-[r]-()
      return
      count(distinct n) as nodes,
      count(distinct r) as relationships,
      count(distinct p) as paths
      """
    )
  end

end
