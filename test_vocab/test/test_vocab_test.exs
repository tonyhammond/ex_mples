defmodule TestVocabTest do
  use ExUnit.Case
  doctest TestVocab

  test "greets the world" do
    assert TestVocab.hello() == :world
  end
end
