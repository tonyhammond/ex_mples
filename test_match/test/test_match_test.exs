defmodule TestMatchTest do
  use ExUnit.Case
  doctest TestMatch

  import TestMatch

  test "greets the world" do
    # assert TestMatch.hello() == :world
    assert length(cypher!("match (n) return n limit 2")) == 2
  end
end
