defmodule Clickhouser.Connection do
  @moduledoc """

  ## Example module

    defmodule MyConnection do
      use Clickhouser.Connection, otp_app: :my_application
    end
  """

  defmacro __using__(otp_app: otp_app) do
    quote bind_quoted: [ otp_app: otp_app ] do
      @otp_app otp_app

      defp get_config do
        Application.get_env(@otp_app, __MODULE__)
      end

      def get_url do
        get_config()
        |> Keyword.get(:url, "http://localhost:8123")
      end

      def execute(%Clickhouser.Query.Select{sql: sql} = query) do
        query
        |> Clickhouser.Query.Select.build_sql
        |> __MODULE__.execute
      end

      def execute(%Clickhouser.Query.Insert{table: table, fields: fields, values: values} = query) do
        query
        |> Clickhouser.Query.Insert.build_sql
        |> __MODULE__.execute
      end

      def execute(query) do
        IO.inspect query
        case HTTPoison.post(get_url(), query) do
          {:ok, %{body: body, status_code: 200}} -> {{:ok, body}}
          {:ok, %{body: body}} -> {{:error, body}}
          _ -> {{:error, "unexpected error"}}
        end
      end

      def ping do
        Clickhouser.select("SELECT 1 AS ping")
        |> execute
        |> parse_data
      end

      #TODO: wrong place for parsing data
      def parse_data({{:ok, result}} = _response) do
        %{"data" => data} = Poison.Parser.parse!(result)
        data
      end
    end
  end
end
