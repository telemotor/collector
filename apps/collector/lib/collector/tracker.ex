defmodule Collector.Tracker do
  import Clickhouser, only: [insert: 3]

  def click(%Collector.Event.Click{customuserid: custom_user_id, userid: user_id, xpath: xpath, href: href, useragent: ua, referer: ref, sessionid: session_id, x: x, y: y}) do
    event_type = 1
    site_id = 1
    event_id = UUID.uuid4()
    current = Timex.now
    date = Timex.to_date(current) |> Date.to_string
    datetime = Timex.format!(current, "{YYYY}-{0M}-{0D} {h24}:{m}:{s}")

    insert(
      "events",
      ["EventDate", "EventTime", "EventID", "EventType", "UserID", "CustomUserID", "SiteID", "Xpath", "Href", "UserAgent", "Referer", "SessionID", "X", "Y"],
      [[date, datetime, event_id, event_type, user_id, custom_user_id, site_id, xpath, href, ua, ref, session_id, x, y]]
    )
  end

  def pageview(%Collector.Event.PageView{customuserid: custom_user_id, userid: user_id, href: href, sessionid: session_id, useragent: ua, referer: ref}) do
    event_type = 2
    site_id = 1
    event_id = UUID.uuid4()
    current = Timex.now
    date = Timex.to_date(current) |> Date.to_string
    datetime = Timex.format!(current, "{YYYY}-{0M}-{0D} {h24}:{m}:{s}")

    insert(
      "events",
      ["EventDate", "EventTime", "EventID", "EventType", "UserID", "CustomUserID", "SiteID", "Xpath", "Href", "UserAgent", "Referer", "SessionID", "X", "Y"],
      [[date, datetime, event_id, event_type, user_id, custom_user_id, site_id, "", href, ua, ref, session_id, 0, 0]]
    )
  end

#  defp magik_xpath(xpath) do
#    source = xpath
#    |> String.trim("/")
#    |> String.split("/")
#
#    magik_xpath(source, [], "")
#  end
#
#  defp magik_xpath([], result, _) do
#    result
#  end
#
#  defp magik_xpath(source, result, base_xpath) do
#    [h | t] = source
#    newbase = "#{base_xpath}/#{h}"
#    magik_xpath(t, result ++ [newbase], newbase)
#  end
end
