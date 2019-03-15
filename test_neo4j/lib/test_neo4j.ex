defmodule TestNeo4j do
  @moduledoc """
    Top-level module used in "Property graphs in Elixir" post.
    """

  @graphs_dir "#{:code.priv_dir(:test_neo4j)}/graphs/"
  @graphgists_dir "#{:code.priv_dir(:test_neo4j)}/graphgists/"
  @queries_dir "#{:code.priv_dir(:test_neo4j)}/queries/"

  @books_graph_file "books.cypher"
  @movies_graph_file "movies.cypher"

  @test_graph_file "books.cypher"
  @test_graphgist_file "template.adoc"
  @test_query_file "get_one_node.cypher"

  ## graphs
  def read_graph() do
    File.read!(@graphgists_dir <> @test_graph_file)
  end

  def read_graph(graph_file) do
    File.read!(@graphs_dir <> graph_file)
  end

  def books() do
    File.read!(@graphs_dir <> @books_graph_file)
  end

  def movies() do
    File.read!(@graphs_dir <> @movies_graph_file)
  end

  ## graphgists
  def read_graphgist() do
    File.read!(@graphgists_dir <> @test_graphgist_file)
  end

  def read_graphgist(graphgist_file) do
    File.read!(@graphgists_dir <> graphgist_file)
  end

  # % ls
  # Aardvark.adoc				neo4j_icij.adoc
  # bank-fraud-detection.adoc
  # Competence_Management.adoc		books.adoc				network-routing.adoc
  # Credit_Card_Fraud_Detection.adoc	central_hospital_of_asturias.adoc		pharma_drugs_targets.adoc
  # GeoptimaAllocation.adoc			finding_influencers.adoc
  # Menus_in_NYPL.adoc			graphgist_water.adoc
  # NetworkDataCenterManagement1.adoc		template.adoc
  # Offshore_Leaks_and_Azerbaijan.adoc
  # Organizational_learning.adoc			yellowstone-gist.adoc
  # SupplyChainManagement.adoc			zombie.adoc
  # aws-infrastructure.adoc

  # DoctorFinder.adoc - 7 dash, not 4
  # syntax.adoc - //output
  # index.adoc - //output
  # treatment_planners.adoc - //output

  # hierarchy_graphgist.adoc - no //setup
  # citation_patterns.adoc- no //setup
  # project_management.adoc - extra \n after //setup
  # neo4j-contact-networks.adoc - //hidden

  # northwind-graph.adoc - csv, no //setup
  # marchMadnessBracketBuilder.adoc - csv, no //setup

  def parse(graphgist) do
    result =
      Regex.run(~r/\/setup\n(\/\/hide\n)*(\/\/output\n)*\[source,\s*cypher\]\n\-\-\-\-.*\n((.|\n)*)\-\-\-\-.*\n/Um, graphgist)
      # IO.inspect result
    result |>
    case do
      [_,cypher,_] -> cypher
      [_,_,cypher,_] -> cypher    # //hide\n
      [_,_,_,cypher,_] -> cypher  # //hide\n//output]\n
      _ -> ""
    end
  end

  ## queries
  def read_query() do
    File.read!(@queries_dir <> @test_query_file)
  end

  def read_query(query_file) do
    File.read!(@queries_dir <> query_file)
  end

  def node1(conn) do
    Bolt.Sips.query!(conn, read_query("node1.cypher"))
  end

  def nodes(conn) do
    Bolt.Sips.query!(conn, read_query("nodes.cypher"))
  end

  def relationship1(conn) do
    Bolt.Sips.query!(conn, read_query("relationship1.cypher"))
  end

  def relationships(conn) do
    Bolt.Sips.query!(conn, read_query("relationships.cypher"))
  end

  def node1_and_relationships(conn) do
    Bolt.Sips.query!(conn, read_query("node1_and_relationships.cypher"))
  end

  def nodes_and_relationships(conn) do
    Bolt.Sips.query!(conn, read_query("nodes_and_relationships.cypher"))
  end

  def path1(conn) do
    Bolt.Sips.query!(conn, read_query("path1.cypher"))
  end

  def paths(conn) do
    Bolt.Sips.query!(conn, read_query("paths.cypher"))
  end

  ## database
  def init() do
    Bolt.Sips.conn
  end

  def clear(conn) do
    Bolt.Sips.query!(conn,
    """
    match (n) optional match (n)-[r]-() delete n,r
    """)
  end

  def reset(conn) do
    Bolt.Sips.query!(conn,
    """
    match (n) optional match (n)-[r]-() delete n,r
    """)
  end

  def test(conn) do
    Bolt.Sips.query!(conn,
    """
    match (n) optional match p = (n)-[r]-()
    return
    count(distinct n) as nodes,
    count(distinct r) as relationships,
    count(distinct p) as paths
    """)
  end

  def apps() do
    # Application.started_applications()
    Process.info(Process.whereis(Bolt.Sips))
    # Process.info(Process.whereis(Bolt.Sips.ConfigAgent))
  end
end
