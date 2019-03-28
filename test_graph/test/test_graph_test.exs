defmodule TestGraphTest do
  use ExUnit.Case
  doctest TestGraph

  test "greets the world" do
    assert TestGraph.hello() == :world
  end
end
