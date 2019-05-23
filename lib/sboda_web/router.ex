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

  # can use graphql to cut out versioning and many other challenges
  scope "/api/v1", SbodaWeb do
    pipe_through :api

    resources "/promocodes", PromocodeController, only: [:index, :create] # create and also list all promocodes
    get("/promocodes/active", PromocodeController, :active) # list all active promocodes
    post("/promocodes/config_radius", PromocodeController, :config_radius) # change the radius of the event/promocode
    post("/ride/request", RideController, :request) #request a ride with promocode
  end
end
