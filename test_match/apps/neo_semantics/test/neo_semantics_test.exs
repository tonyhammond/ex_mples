defmodule NeoSemanticsTest do
  use ExUnit.Case
  doctest NeoSemantics

  test "greets the world" do
    assert NeoSemantics.hello() == :world
  end
end
