defmodule Collector.Reporter do
  import Clickhouser, only: [select: 1]

  def used_pages do
    select("SELECT Href as href, count() as total FROM events WHERE EventType = 2 GROUP BY Href ORDER BY total DESC")
    |> Clickhouser.Connection.execute
    |> Clickhouser.Connection.parse_data
  end

  def event_report(data) do
    IO.inspect data
    process_events(data, [], [])
  end

  def process_events([], _, result) do
    result
  end

  def process_events(payload, agg, results) do
    [head | tail] = payload
    conditions = agg ++ [head]
    res = query_events(conditions)
    process_events(tail, conditions, results ++ res)
  end

  def query_events(conditions) do
    conditions
    |> Enum.map(&build_join/1)
    |> Enum.join(" ANY INNER JOIN ")
    |> build_select_query
    |> select
    |> Clickhouser.Connection.execute
    |> Clickhouser.Connection.parse_data
  end

  def build_join(%{"href" => href, "xpath" => xpath} = _data) do
    "(SELECT UserID FROM events  WHERE Href = '#{href}' AND Xpath = '#{xpath}' GROUP BY UserID)"
  end

  def build_select_query(join_string) do
    case String.contains?(join_string, "ANY INNER JOIN") do
      true -> "SELECT count() as total FROM #{join_string} USING UserID"
      _ -> "SELECT count() as total FROM #{join_string}"
    end
  end
end
