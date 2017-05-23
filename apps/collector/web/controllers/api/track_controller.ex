defmodule Collector.API.TrackController do
  use Collector.Web, :controller

  def click(conn, params) do
    %{req_headers: headers} = conn
    %{"user-agent" => ua, "referer" => ref} = Enum.into(headers, %{})
    %{"customuserid" => customuserid, "userid" => userid, "xpath" => xpath, "href" => href, "sessionid" => sessionid, "x" => x, "y" => y} = params
    {x, _} = Integer.parse(x)
    {y, _} = Integer.parse(y)
    {result} = Collector.Tracker.click(%Collector.Event.Click{
      customuserid: to_string(customuserid),
      userid: to_string(userid),
      xpath: to_string(xpath),
      href: to_string(href),
      sessionid: to_string(sessionid),
      useragent: ua,
      referer: ref,
      x: x,
      y: y
    })
    res = case result do
      {:ok, _} -> "ok"
      {_, error} -> error
    end

    json conn, res
  end

  def view(conn, params) do
    %{req_headers: headers} = conn
    %{"user-agent" => ua, "referer" => ref} = Enum.into(headers, %{})

    %{"customuserid" => customuserid, "userid" => userid, "href" => href, "sessionid" => sessionid} = params
    {result} = Collector.Tracker.pageview(%Collector.Event.PageView{
      customuserid: to_string(customuserid),
      userid: to_string(userid),
      href: to_string(href),
      sessionid: to_string(sessionid),
      useragent: ua,
      referer: ref
    })
    res = case result do
      {:ok, _} -> "ok"
      {_, error} -> error
    end

    json conn, res
  end
end
