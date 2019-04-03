defmodule TestGraph.LPG.Cypher.Client do
  @moduledoc """
  Module providing a simple library for querying LPG models in a Neo4j instance via Cypher.
  """

  # @priv_dir "#{:code.priv_dir(:test_graph)}"
  #
  # @lpg_dir @priv_dir <> "/lpg"
  #
  # @graphs_dir @lpg_dir <> "/graphs/"
  # @graphgists_dir @lpg_dir <> "/graphgists/"
  # @queries_dir @lpg_dir <> "/queries/"
  #
  # ##
  #
  # @books_graph_file "books.cypher"
  # @movies_graph_file "movies.cypher"
  #
  # @temp_graph_file "default.cypher"
  #
  # @test_graph_file "books.cypher"
  # @test_graphgist_file "template.adoc"
  # @test_query_file "node1.cypher"

  import TestGraph.LPG

  @doc """
  Queries database for one node.

  ## Examples

      iex> conn |> node1()
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
          }
        }
      ]
  """
  def node1(conn) do
    Bolt.Sips.query!(conn, read_query("node1.cypher"))
  end

  @doc """
  Queries database for all nodes.

  ## Examples

      iex> conn |> nodes()
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
          }
        },
        ...
      ]
  """
  def nodes(conn) do
    Bolt.Sips.query!(conn, read_query("nodes.cypher"))
  end

  @doc """
  Queries database for all node IDs.

  ## Examples

      iex> conn |> node_ids()
      [
        %{"id(n)" => 1804},
        %{"id(n)" => 1805},
        %{"id(n)" => 1806},
        %{"id(n)" => 1807},
        %{"id(n)" => 6277}
      ]
  """
  def node_ids(conn) do
    Bolt.Sips.query!(conn, read_query("node_ids.cypher"))
  end

  @doc """
  Queries database for one relationship.

  ## Examples

      iex> conn |> relationship1()
      [
        %{
          "r" => %Bolt.Sips.Types.Relationship{
            end: 1548,
            id: 1689,
            properties: %{"role" => "second author"},
            start: 1546,
            type: "AUTHORED_BY"
          }
        }
      ]
  """
  def relationship1(conn) do
    Bolt.Sips.query!(conn, read_query("relationship1.cypher"))
  end

  @doc """
  Queries database for all relationships.

  ## Examples

      iex> conn |> relationships()
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
  def relationships(conn) do
    Bolt.Sips.query!(conn, read_query("relationships.cypher"))
  end

  @doc """
  Queries database for one node and relationships.

  ## Examples

      iex> conn |> node1_and_relationships()
      [
        %{
          "n" => %Bolt.Sips.Types.Node{
            id: 1548,
            labels: ["Author"],
            properties: %{"iri" => "https://twitter.com/josevalim"}
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
  def node1_and_relationships(conn) do
    Bolt.Sips.query!(conn, read_query("node1_and_relationships.cypher"))
  end

  @doc """
  Queries database for all nodes and relationships.

  ## Examples

      iex> conn |> nodes_and_relationships()
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
  def nodes_and_relationships(conn) do
    Bolt.Sips.query!(conn, read_query("nodes_and_relationships.cypher"))
  end

  @doc """
  Queries database for one path.

  ## Examples

      iex> conn |> path1()
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
        }
      ]
  """
    def path1(conn) do
    Bolt.Sips.query!(conn, read_query("path1.cypher"))
  end

  @doc """
  Queries database for all paths.

  ## Examples

      iex> conn |> paths()
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
  def paths(conn) do
    Bolt.Sips.query!(conn, read_query("paths.cypher"))
  end

  ## database
  @doc """
  Opens up a Bolt database connection with the app config.

  ## Examples

      iex> init()
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

      iex> conn |> reset()
      %{stats: %{"nodes-deleted" => 171, "relationships-deleted" => 253}, type: "w"}

  """
  def clear(conn) do
    Bolt.Sips.query!(
      conn,
      """
      match (n) optional match (n)-[r]-() delete n,r
      """
    )
  end

  @doc """
  Deletes all nodes and relationships in database.

  ## Examples

      iex> conn |> reset()
      %{stats: %{"nodes-deleted" => 171, "relationships-deleted" => 253}, type: "w"}

  """
  def reset(conn) do
    Bolt.Sips.query!(
      conn,
      """
      match (n) optional match (n)-[r]-() delete n,r
      """
    )
  end

  @doc """
  Counts nodes, relationships and paths in database.

  ## Examples

      iex> conn |> test()
      [%{"nodes" => 171, "paths" => 506, "relationships" => 253}]

  """
  def test(conn) do
    Bolt.Sips.query!(
      conn,
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
