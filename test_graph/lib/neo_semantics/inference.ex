defmodule NeoSemantics.Inference do
  @moduledoc """
  Module providing simple wrapper functions for the [`neosemantics`](https://github.com/jbarrasa/neosemantics) library
  inference functions.
  """
  ##

  @doc """
  Returns all nodes with label `label` or its sublabels.
  """
  def get_nodes_linked_to(conn, label) do
    cypher = "call semantics.inference.getNodesLinkedTo(\"" <> label <> "\")"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Returns all nodes connected to node with label `label` or its subcategories.
  """
  def get_nodes_with_label(conn, label) do
    cypher = "call semantics.inference.getNodesWithLabel(\"" <> label <> "\")"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Returns all outgoing relationships of type `rel`.
  """
  def get_rels(conn, rel) do
    cypher = "call semantics.inference.getRels(\"" <> rel <> "\")"
    Bolt.Sips.query!(conn, cypher)
  end

end
