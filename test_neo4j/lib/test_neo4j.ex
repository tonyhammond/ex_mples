defmodule TestNeo4j do
  @moduledoc """
  Top-level module used in "[Property graphs and Elixir](https://medium.com/@tonyhammond/property-graphs-and-elixir-13672940804b)" post.

  The post shows how to access Neo4j graph databases with Elixir using the
  [bolt_sips](https://hex.pm/packages/bolt_sips) package. 
  """

  @priv_dir "#{:code.priv_dir(:test_neo4j)}"

  @graphs_dir @priv_dir <> "/graphs/"
  @graphgists_dir @priv_dir <> "/graphgists/"
  @queries_dir @priv_dir <> "/queries/"

  @books_graph_file "books.cypher"
  @movies_graph_file "movies.cypher"

  @test_graph_file "books.cypher"
  @test_graphgist_file "template.adoc"
  @test_query_file "node1.cypher"

  ## graphs

  @doc """
  Reads a default Cypher graph from the graphs library.

  ## Examples

      iex> read_graph()
      "//\\n// create nodes\\n//\\nCREATE\\n(book:Book {\\n    iri: " <> ...

  """
  def read_graph() do
    File.read!(@graphs_dir <> @test_graph_file)
  end

  @doc """
  Reads a user Cypher graph from the graphs library.

  ## Examples

      iex> read_graph("books.cypher")
      "//\\n// create nodes\\n//\\nCREATE\\n(book:Book {\\n    iri: " <> ...

  """
  def read_graph(graph_file) do
    File.read!(@graphs_dir <> graph_file)
  end

  @doc """
  Reads a `Books` graph from the graphs library.

  ## Examples

      iex> books()
      "//\\n// create nodes\\n//\\nCREATE\\n(book:Book {\\n    iri: " <> ...

  """
  def books() do
    File.read!(@graphs_dir <> @books_graph_file)
  end

  @doc """
  Reads a `Movies` graph from the graphs library.

  ## Examples

      iex> movies()
      "CREATE (TheMatrix:Movie {title:'The Matrix', released:1999," <> ...

  """
  def movies() do
    File.read!(@graphs_dir <> @movies_graph_file)
  end

  ## graphgists

  @doc """
  Reads a default graphgist from the graphgists library.

  ## Examples

      iex> read_graphgist()
      "= REPLACEME: TITLE OF YOUR GRAPHGIST\\n:neo4j-version: 2.3.0\\n:author:" <> ...

  """
  def read_graphgist() do
    File.read!(@graphgists_dir <> @test_graphgist_file)
  end

  @doc """
  Reads a user graphgist from the graphgists library.

  ## Examples

      iex> read_graphgist("template.adoc")
      "= REPLACEME: TITLE OF YOUR GRAPHGIST\\n:neo4j-version: 2.3.0\\n:author:" <> ...

  """
  def read_graphgist(graphgist_file) do
    File.read!(@graphgists_dir <> graphgist_file)
  end

  @doc """
  Parses a graphgist to return a Cypher graph.

  ## Examples

      iex> parse(read_graphgist())
      "CREATE\\n  (a:Person {name: 'Alice'}),\\n  (b:Person {name: 'Bob'}),\\n" <> ...

  """
  def parse(graphgist) do
    Regex.run(
      ~r/\/setup\n(\/\/hide\n)*(\/\/output\n)*\[source,\s*cypher\]\n\-\-\-\-.*\n((.|\n)*)\-\-\-\-.*\n/Um,
      graphgist
    )
    |> case do
      [_, cypher, _] -> cypher       # //hide\n
      [_, _, cypher, _] -> cypher    # //hide\n//output]\n
      [_, _, _, cypher, _] -> cypher
      _ -> ""
    end
  end

  ## queries

  @doc """
  Reads a default Cypher query from the queries library.

  ## Examples

      iex> read_query()
      "match (n) return n limit 1\\n"

  """
  def read_query() do
    File.read!(@queries_dir <> @test_query_file)
  end

  @doc """
  Reads a named Cypher query from the queries library.

  ## Examples

      iex> read_query("nodes.cypher")
      "match (n) return n\\n"

  """
  def read_query(query_file) do
    File.read!(@queries_dir <> query_file)
  end

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
