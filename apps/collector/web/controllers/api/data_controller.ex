defmodule Collector.API.DataController do
  use Collector.Web, :controller

  def used_pages(conn, _params) do
    json conn, Collector.Reporter.used_pages()
  end

  def get_event_report(conn, _params) do
    {:ok, data, _conn_details} = Plug.Conn.read_body(conn)
    res = Collector.Reporter.event_report(Poison.decode!(data))
    IO.inspect res
    json conn, res
  end
end
