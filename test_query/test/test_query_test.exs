defmodule TestQueryTest do
  use ExUnit.Case
  doctest TestQuery

  test "greets the world" do
    assert TestQuery.hello() == :world
  end
end
