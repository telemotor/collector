defmodule Clickhouser.InsertWorker do
  use GenServer

  @timeout 2_000

  def start_link() do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{}, @timeout}
  end

  def handle_info(:timeout, _) do
    Clickhouser.InsertQueue.get_queue()
    |> Enum.map(&map_insert/1)
    |> group_inserts
    |> Map.to_list
    |> Enum.map(&build_insert/1)
    |> Enum.map(&Clickhouser.Connection.execute/1)

    {:noreply, %{}, @timeout}
  end

  def map_insert(%Clickhouser.Query.Insert{table: table, fields: fields, values: values}) do
    {md5([table] ++ fields), table, fields, values}
  end

  def group_inserts([], output) do
    output
  end

  def group_inserts(input, output \\ %{}) do
    [{hash, table, fields, values}|tail] = input
    result = case Map.has_key?(output, hash) do
      true -> output
      _ -> Map.put(output, hash, {table, fields, []})
    end

    group_inserts(tail, Map.update!(result, hash, fn arr ->
      {table, fields, ins} = arr
      {table, fields, ins ++ values}
    end))
  end

  def build_insert({_hash, {table, fields, values}}) do
    %Clickhouser.Query.Insert{table: table, fields: fields, values: values}
  end

  defp md5(data) do
    Base.encode16(:erlang.md5(data), case: :lower)
  end
end
