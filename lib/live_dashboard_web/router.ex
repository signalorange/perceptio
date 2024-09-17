defmodule LiveDashboardWeb.Router do
  use LiveDashboardWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LiveDashboardWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveDashboardWeb do
    pipe_through :browser
    get "/", RedirectController, :redirector
    live "/entrepot", IndicatorLive.Indicators
  end

  scope "/api", LiveDashboardWeb do
    pipe_through :api

    get "/nb_commandes_ln", APIController, :nb_commandes_ln
    get "/nb_commandes_ln_types", APIController, :nb_commandes_ln_types
    get "/nb_commandes_ln_routes", APIController, :nb_commandes_ln_routes
    get "/nb_commandes_ln_cable", APIController, :nb_commandes_ln_cable
    get "/nb_commandes_ln_ext", APIController, :nb_commandes_ln_ext
    get "/nb_commandes_ln_printed", APIController, :nb_commandes_ln_printed
    get "/nb_commandes_ln_afaire", APIController, :nb_commandes_ln_afaire
    get "/nb_commandes_ln_encours", APIController, :nb_commandes_ln_encours
    get "/nb_commandes_ln_faites", APIController, :nb_commandes_ln_faites
    get "/nb_commandes_ln_livrees", APIController, :nb_commandes_ln_livrees
    get "/nb_commandes_ln_jour", APIController, :nb_commandes_ln_jour
    get "/nb_commandes_ln_semaine", APIController, :nb_commandes_ln_semaine
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  import Phoenix.LiveDashboard.Router

  scope "/dev" do
    pipe_through :browser

    live_dashboard "/dashboard", metrics: LiveDashboardOrigWeb.Telemetry
    #forward "/mailbox", Plug.Swoosh.MailboxPreview
  end
end

defmodule LiveDashboardWeb.RedirectController do
  use LiveDashboardWeb, :controller
  @send_to "/entrepot"

  def redirector(conn, _params), do: redirect(conn, to: @send_to)

end
