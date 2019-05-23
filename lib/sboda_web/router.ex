defmodule SbodaWeb.Router do
  use SbodaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SbodaWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # can use graphql to cut out versioning
  scope "/api/v1", SbodaWeb do
    pipe_through :api

    resources "/promocodes", PromocodeController, only: [:index, :create]
    get("/promocodes/active", PromocodeController, :active)
    post("/promocodes/configure_title", PromocodeController, :title_config)
    post("/ride/request", RideController, :request)
  end
end
