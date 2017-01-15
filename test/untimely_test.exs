defmodule UntimelyTest do
  use ExUnit.Case
  doctest Untimely

  test "the truth" do
    Untimely.Server.wait_for_task()

    assert_receive(:started, 1000)
  end
end
