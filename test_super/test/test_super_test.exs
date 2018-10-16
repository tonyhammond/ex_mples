defmodule TestSuperTest do
  use ExUnit.Case
  doctest TestSuper

  test "greets the world" do
    assert TestSuper.hello() == :world
  end
end
