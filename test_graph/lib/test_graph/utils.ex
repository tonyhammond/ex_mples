defmodule TestGraph.Utils do
  @moduledoc """
  Module providing helper functions.
  """

  @doc """
  Lists toplevel module's functions.
  """
  def help() do
    inspect(TestGraph.__info__(:functions), limit: :infinity)
  end

  @doc """
  Lists named module's functions.
  """
  def help(module) do
    inspect(module.__info__(:functions), limit: :infinity)
  end

end
