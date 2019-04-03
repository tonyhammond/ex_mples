defmodule NeoSemantics.Inference do
  @moduledoc """
  Module providing simple wrapper functions for the `neosemantics` library
  inference functions.
  """
  ##

  @doc """
  Returns all nodes with label `virt_label` or its sublabels.
  """
  def get_nodes_linked_to(conn, virt_label) do
    cypher = "call semantics.inference.getNodesLinkedTo(virt_label)"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Returns all nodes connected to node `cat_node` or its subcategories.
  """
  def get_nodes_with_label(conn, cat_node) do
    cypher = "call semantics.inference.getNodesWithLabel(cat_node)"
    Bolt.Sips.query!(conn, cypher)
  end

  @doc """
  Returns all outgoing relationships of type `virt_rel`.
  """
  def get_rels(conn, virt_rel) do
    cypher = "call semantics.inference.getRels(virt_rel)"
    Bolt.Sips.query!(conn, cypher)
  end

end
