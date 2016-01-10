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

    get "/", PageController, :index

    get "/login", SessionController, :new, as: :login
    post "/login", SessionController, :create, as: :login
    delete "/logout", SessionController, :delete, as: :logout
    get "/logout", SessionController, :delete, as: :logout

    resources "/users", UserController
    #resources "/sensor_events", SensorEventController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  scope "/api", DtWeb do
    pipe_through :api

    post "/login", SessionController, :api_create, as: :api_login

    #resources "/sensor_events", SensorEventController, only: [:create]
    resources "/sensor_events", SensorEventController, except: [:new, :edit]
  end

end
