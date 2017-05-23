defmodule Clickhouser.Query.Select do
  #TODO: add params and bind_param method
  defstruct [sql: nil]

  @doc """

  ## Examples
    Only this two types of selects currently supported!

    iex> query = %Clickhouser.Query.Select{sql: "SELECT 1 AS hello"}
    iex> Clickhouser.Query.Select.build_sql(query)
    "SELECT 1 AS hello FORMAT JSON"

    iex> query = %Clickhouser.Query.Select{sql: "SELECT 1 AS hello format JSON"}
    iex> Clickhouser.Query.Select.build_sql(query)
    "SELECT 1 AS hello format JSON"
  """
  def build_sql(%Clickhouser.Query.Select{sql: sql} = _query) do
    case String.downcase(sql) |> String.ends_with?("format json") do
      true -> sql
      false -> sql <> " FORMAT JSON"
    end
  end
end
