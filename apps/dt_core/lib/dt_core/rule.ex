defmodule DtCore.Rule do

  alias DtCore.Event

  require Logger

  def apply(event, expression) when is_binary(expression) do
    _apply event, String.to_char_list(expression)
  end

  def apply(event, expression) when is_list(expression) do
    _apply event, expression
  end

  defp _apply(event = %Event{}, expression) do
    grammar = ABNF.load_file "priv/rules.abnf"
    res = ABNF.apply grammar, "if-rule", expression, %{}
    values = Enum.at res.values, 0
    expression = values.code
    {value, _binding} = Code.eval_string expression, [event: event], __ENV__
    value
  end

end
