defmodule BreakingRaft.Model.HistoryTest do
  use ExUnit.Case, async: true

  alias BreakingRaft.Model.History

  test "empty history can be created" do
    assert History.new() == []
  end
end
