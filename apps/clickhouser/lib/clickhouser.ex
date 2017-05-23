defmodule Clickhouser do
  @moduledoc """
  Documentation for Clickhouser.
  """

  def select(sql) do
    %Clickhouser.Query.Select{sql: sql}
  end

  def insert(table, fields, values) do
    %Clickhouser.Query.Insert{table: table, fields: fields, values: values}
  end
end
