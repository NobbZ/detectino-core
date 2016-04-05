defmodule DtWeb.Router do
  use DtWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", DtWeb do
    pipe_through [:browser, :browser_session] # Use the default browser stack
    get "/*path", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", DtWeb do
    pipe_through :api

    post "/login", SessionApiController, :create, as: :api_login
  end

end
