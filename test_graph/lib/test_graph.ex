defmodule TestGraph do
  @moduledoc """
  Top-level module used in
  "[Graph to graph with Elixir]()" post.
  """

  def help() do
    __MODULE__.__info__(:functions)
  end

  def help(module) do
    module.__info__(:functions)
  end

end
