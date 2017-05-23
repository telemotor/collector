defmodule Clickhouser.Query.Insert do
  defstruct [table: nil, fields: nil, values: nil]

  @doc """

  ## Examples
    Only this one type fo insert currently supported!

    iex> query = %Clickhouser.Query.Insert{fields: ["field1", "field2"], table: "supertable", values: [["data1", "data2"], ["qwe1", "qwe2"]]}
    iex> Clickhouser.Query.Insert.build_sql(query)
    "INSERT INTO supertable (field1, field2) VALUES ('data1', 'data2'), ('qwe1', 'qwe2')"

  """
  def build_sql(%Clickhouser.Query.Insert{table: table, fields: fields, values: values} = _query) do
    fields = join_items(fields)
    values = build_values(values)
    "INSERT INTO #{table} (#{fields}) VALUES #{values}"
  end

  defp join_items(fields) do
    fields
    |> Enum.join(", ")
  end

  defp join_values(values) do
    values
    |> Enum.map(fn (elem) ->
      case is_binary(elem) do
        true -> "'#{elem}'"
        _ -> elem
      end
    end)
    |> Enum.join(", ")
  end

  defp build_values(values) do
    Enum.map(values, fn (e) ->
      case is_list(e) do
        true -> "(" <> join_values(e) <> ")"
        false -> e
      end
    end)
    |> join_items
  end
end
