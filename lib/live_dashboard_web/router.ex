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
  end
end

defmodule LiveDashboardWeb.RedirectController do
  use LiveDashboardWeb, :controller
  @send_to "/entrepot"

  def redirector(conn, _params), do: redirect(conn, to: @send_to)

end
