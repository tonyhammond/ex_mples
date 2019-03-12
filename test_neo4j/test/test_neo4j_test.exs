defmodule TestNeo4jTest do
  use ExUnit.Case
  doctest TestNeo4j

  test "greets the world" do
    assert TestNeo4j.hello() == :world
  end
end
