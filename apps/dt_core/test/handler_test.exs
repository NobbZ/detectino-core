defmodule DtCore.HandlerTest do
  use DtCore.EctoCase
  doctest DtCore

  alias DtCore.Handler
  alias DtCore.Event

  @missing_port_ev %Event{address: "10", value: "any value", type: :an_atom, subtype: :another_atom}
  @missing_addr_ev %Event{port: 10, value: "any value", type: :an_atom, subtype: :another_atom}
  @missing_type_ev %Event{address: "10", port: 10, value: "any value", subtype: :another_atom}
  @missing_subtype_ev %Event{address: "10", port: 10, value: "any value", type: :an_atom}
  @wrong_port_addr %Event{address: "1234", port: "10", value: "any value", type: :an_atom, subtype: :another_atom}
  @wrong_addr %Event{address: 1234, port: 10, value: "any value", type: :an_atom, subtype: :another_atom}

  @valid_ev1 %Event{address: "1234", port: 10, value: "any value", type: :an_atom, subtype: :another_atom}

  test "new event raises FunctionClauseError because missing port" do
    assert_raise FunctionClauseError, fn -> 
      Handler.put(@missing_port_ev)
    end
  end

  test "new event raises FunctionClauseError because missing address" do
    assert_raise FunctionClauseError, fn -> 
      Handler.put(@missing_addr_ev)
    end
  end

  test "new event raises FunctionClauseError because missing type" do
    assert_raise FunctionClauseError, fn -> 
      Handler.put(@missing_type_ev)
    end
  end

  test "new event raises FunctionClauseError because missing subtype" do
    assert_raise FunctionClauseError, fn -> 
      Handler.put(@missing_subtype_ev)
    end
  end

  test "new event raises FunctionClauseError because wrong address format" do
    assert_raise FunctionClauseError, fn -> 
      Handler.put(@wrong_addr)
    end
  end

  test "new event raises FunctionClauseError because wrong port format" do
    assert_raise FunctionClauseError, fn -> 
      Handler.put(@wrong_port_addr)
    end
  end

end
