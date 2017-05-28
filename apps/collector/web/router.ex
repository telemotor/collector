defmodule Collector.Router do
  use Collector.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug, origin: ["*"]
  end

  scope "/api", Collector do
      pipe_through :api

      # collector
      post "/click", API.TrackController, :click
      post "/pageview", API.TrackController, :view

      # api
      get "/data/used_pages", API.DataController, :used_pages
      post "/data/get_event_report", API.DataController, :get_event_report
    end
end
