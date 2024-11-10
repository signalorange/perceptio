defmodule PerceptioWeb.Router do
  use PerceptioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PerceptioWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PerceptioWeb do
    pipe_through :browser
    get "/", RedirectController, :redirector
    live "/entrepot", IndicatorLive.EntrepotDashboard
    live "/cable_dashboard", IndicatorLive.CableDashboardLive
  end

  scope "/api", PerceptioWeb do
    pipe_through :api
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # import Phoenix.LiveDashboard.Router

  # scope "/dev" do
  #   pipe_through :browser

  #   perceptio "/dashboard", metrics: PerceptioWeb.Telemetry
  #   #forward "/mailbox", Plug.Swoosh.MailboxPreview
  # end
end

defmodule PerceptioWeb.RedirectController do
  use PerceptioWeb, :controller
  @send_to "/entrepot"

  def redirector(conn, _params), do: redirect(conn, to: @send_to)

end
