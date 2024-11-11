defmodule Perceptio.DataStore do
  use GenServer
  alias Phoenix.PubSub

  @refresh_interval :timer.seconds(60) # 5 minutes

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    :ets.new(:perceptio_store, [:set, :public, :named_table])
    # Fetch initial data
    send(self(), :refresh)

    schedule_refresh()
    {:ok, %{}}
  end

  def handle_info(:refresh, state) do
    # Fetch data from SQL
    order_lines_status = nb_commandes_ln()
    order_lines_types = nb_commandes_ln_types()
    order_lines_routes = nb_commandes_ln_routes()
    hourly_trend_today = nb_commandes_ln_jour()
    hourly_trend_week = nb_commandes_ln_semaine()

    # Store in ETS
    :ets.insert(:perceptio_store, {:order_lines_status, order_lines_status})
    :ets.insert(:perceptio_store, {:order_lines_types, order_lines_types})
    :ets.insert(:perceptio_store, {:order_lines_routes, order_lines_routes})
    :ets.insert(:perceptio_store, {:hourly_trend_today, hourly_trend_today})
    :ets.insert(:perceptio_store, {:hourly_trend_week, hourly_trend_week})

    # Broadcast changes
    PubSub.broadcast(Perceptio.PubSub, "order_lines_status", {:order_lines_status_updated, order_lines_status})
    PubSub.broadcast(Perceptio.PubSub, "order_lines_types", {:order_lines_types_updated, order_lines_types})
    PubSub.broadcast(Perceptio.PubSub, "order_lines_routes", {:order_lines_routes_updated, order_lines_routes})
    PubSub.broadcast(Perceptio.PubSub, "hourly_trend_today", {:hourly_trend_today_updated, hourly_trend_today})
    PubSub.broadcast(Perceptio.PubSub, "hourly_trend_week", {:hourly_trend_week_updated, hourly_trend_week})

    schedule_refresh()
    {:noreply, state}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  # Client API
  def get_order_lines_status do
    case :ets.lookup(:perceptio_store, :order_lines_status) do
      [{:order_lines_status, data}] -> data
      [] -> nil
    end
  end

  def get_order_lines_types do
    case :ets.lookup(:perceptio_store, :order_lines_types) do
      [{:order_lines_types, data}] -> data
      [] -> nil
    end
  end

  def get_order_lines_routes do
    case :ets.lookup(:perceptio_store, :order_lines_routes) do
      [{:order_lines_routes, data}] -> data
      [] -> nil
    end
  end

  def get_hourly_trend_today do
    case :ets.lookup(:perceptio_store, :hourly_trend_today) do
      [{:hourly_trend_today, data}] -> data
      [] -> nil
    end
  end

  def get_hourly_trend_week do
    case :ets.lookup(:perceptio_store, :hourly_trend_week) do
      [{:hourly_trend_week, data}] -> data
      [] -> nil
    end
  end

  def convert_tds_result_to_map({:ok, %Tds.Result{columns: columns, rows: rows}}) do
    # Convert each row into a map with the corresponding column names
    data =
      Enum.map(rows, fn row ->
        Enum.zip(columns, row) |> Enum.into(%{})
      end)

    data
  end

  defp nb_commandes_ln do
    # Replace with your actual SQL queries
    query = "with livrees as (
              select
                  ve_livraisons_ln.id
              from ve_livraisons_ln with(nolock)
              inner join xx_usagers with(nolock) on xx_usagers.id = ve_livraisons_ln.created_by
              where xx_usagers.xx_groupes_id in ('ENTREPOT', 'ENTREPOT_INVENTAIRE', 'SUPERVISEUR_ENTREPOT')
                AND ve_livraisons_ln.qte > 0
                AND ve_livraisons_ln.isstock = 1
                and ve_livraisons_ln.type = 0
                AND ve_livraisons_ln.created_date BETWEEN
                  -- Start time: 5 AM today or 5 AM yesterday, depending on the current time
                  DATEADD(HOUR, 5, CONVERT(DATETIME,
                    CASE
                      WHEN DATEPART(HOUR, GETDATE()) >= 5 THEN CONVERT(DATE, GETDATE())  -- today
                      ELSE CONVERT(DATE, DATEADD(DAY, -1, GETDATE()))  -- yesterday
                    END
                  ))
                AND
                  -- End time: 4:59 AM tomorrow or today, depending on the current time
                  DATEADD(MINUTE, -1, DATEADD(HOUR, 5, CONVERT(DATETIME,
                    CASE
                      WHEN DATEPART(HOUR, GETDATE()) >= 5 THEN CONVERT(DATE, DATEADD(DAY, 1, GETDATE()))  -- tomorrow
                      ELSE CONVERT(DATE, GETDATE())  -- today
                    END
                  )))
              )
              , somme as (SELECT
                        coalesce((select count(id) from livrees),0) as livrees,
                        coalesce(sum(iif(coalesce(statut,0) = 4,1,0)),0) as completees,
                        coalesce(sum(iif(coalesce(statut,0) = 3.5,1,0)),0) as pretes,
                        coalesce(sum(iif(coalesce(statut,0) = 3,1,0)),0) as encours,
                        coalesce(sum(iif(coalesce(statut,0) = 2,1,0)),0) as imprimees,
                        coalesce(sum(iif(coalesce(statut,0) = 1,1,0)),0) as afaire
                      FROM ELEC_IND_COMMANDES_LN with(nolock)
                  )
              select livrees,
                      completees,
                      pretes,
                      encours,
                      imprimees,
                      afaire,
                      (livrees+completees+encours+imprimees+afaire) as total
              from somme"
    {:ok, %Tds.Result{columns: _, rows: rows}} = Perceptio.Repo.query(query, [])

    # Convert rows to list of maps with column names as keys
    rows
    |> Enum.map(fn [livrees, completees, pretes, encours, imprimees, afaire, total] ->
      %{
        livrees: livrees,
        completees: completees,
        pretes: pretes,
        encours: encours,
        imprimees: imprimees,
        afaire: afaire,
        total: total
      }
    end)
  end

  defp nb_commandes_ln_jour do
    # Replace this with your logic to retrieve the value
    query = "select coalesce(livrees,0) as livrees,
              coalesce(completees,0)as completees,
              coalesce(encours,0) as encours,
              coalesce(imprimees,0) as imprimees,
              coalesce(afaire,0) as afaire,
              coalesce(livrees,0)+coalesce(completees,0)+coalesce(encours,0)+coalesce(imprimees,0)+coalesce(afaire,0) as total ,
              format(dateAjout, 'HH') as heure
              from ELEC_1h_COMMANDES_LN with(nolock)
            where dateAjout BETWEEN
                -- Start time: 5 AM today or 5 AM yesterday, depending on the current time
                DATEADD(HOUR, 5, CONVERT(DATETIME,
                    CASE
                        WHEN DATEPART(HOUR, GETDATE()) >= 5 THEN CONVERT(DATE, GETDATE())  -- today
                        ELSE CONVERT(DATE, DATEADD(DAY, -1, GETDATE()))  -- yesterday
                    END
                ))
            AND
                -- End time: 4:59 AM tomorrow or today, depending on the current time
                DATEADD(MINUTE, -1, DATEADD(HOUR, 5, CONVERT(DATETIME,
                    CASE
                        WHEN DATEPART(HOUR, GETDATE()) >= 5 THEN CONVERT(DATE, DATEADD(DAY, 1, GETDATE()))  -- tomorrow
                        ELSE CONVERT(DATE, GETDATE())  -- today
                    END
                )))
                        order by dateAjout asc"
    {:ok, %Tds.Result{columns: _, rows: rows}} = Perceptio.Repo.query(query, [])

    # Convert rows to list of maps with column names as keys
    rows
    |> Enum.map(fn [livrees, completees, encours, imprimees, afaire, total, heure] ->
      %{
        livrees: livrees,
        completees: completees,
        encours: encours,
        imprimees: imprimees,
        afaire: afaire,
        total: total,
        heure: heure
      }
    end)
  end

  defp nb_commandes_ln_semaine do
    # Replace this with your logic to retrieve the value
    query = "with donnees as (
              select
                  livrees as livrees,
                  completees as completees,
                  encours as encours,
                  imprimees as imprimees,
                  afaire as afaire,
                  livrees+completees+encours+imprimees+afaire as total,
                  dateAjout
              from ELEC_1h_COMMANDES_LN
              where dateAjout not BETWEEN
                  -- Start time: 5 AM today or 5 AM yesterday, depending on the current time
                  DATEADD(HOUR, 5, CONVERT(DATETIME,
                      CASE
                          WHEN DATEPART(HOUR, GETDATE()) >= 5 THEN CONVERT(DATE, GETDATE())  -- today
                          ELSE CONVERT(DATE, DATEADD(DAY, -1, GETDATE()))  -- yesterday
                      END
                  ))
              AND
                  -- End time: 4:59 AM tomorrow or today, depending on the current time
                  DATEADD(MINUTE, -1, DATEADD(HOUR, 5, CONVERT(DATETIME,
                      CASE
                          WHEN DATEPART(HOUR, GETDATE()) >= 5 THEN CONVERT(DATE, DATEADD(DAY, 1, GETDATE()))  -- tomorrow
                          ELSE CONVERT(DATE, GETDATE())  -- today
                      END
                  )))
              AND DATEPART(WEEKDAY, dateAjout) NOT IN (7,1) -- exclure samedi et dimanche
              )

              select
                  coalesce(avg(livrees),0) as livrees,
                  coalesce(avg(completees),0) as completees,
                  coalesce(avg(encours),0) as encours,
                  coalesce(avg(imprimees),0) as imprimees,
                  coalesce(avg(afaire),0) as afaire,
                  coalesce(avg(total),0) as total,
                  format(dateAjout, 'HH') as heure
              from donnees
              group by format(dateAjout, 'HH')"
    {:ok, %Tds.Result{columns: _, rows: rows}} = Perceptio.Repo.query(query, [])

    # Convert rows to list of maps with column names as keys
    rows
    |> Enum.map(fn [livrees, completees, encours, imprimees, afaire, total, heure] ->
      %{
        livrees: livrees,
        completees: completees,
        encours: encours,
        imprimees: imprimees,
        afaire: afaire,
        total: total,
        heure: heure
      }
    end)
  end

  defp nb_commandes_ln_types do
    # Replace this with your logic to retrieve the value
    query = "
        SELECT
          type as type,
          0 as livrees,
          sum(iif(coalesce(statut,0) = 4,1,0)) as completees,
          sum(iif(coalesce(statut,0) = 3.5,1,0)) as pretes,
          sum(iif(coalesce(statut,0) = 3,1,0)) as encours,
          sum(iif(coalesce(statut,0) = 2,1,0)) as imprimees,
          sum(iif(coalesce(statut,0) = 1,1,0)) as afaire
        FROM ELEC_IND_COMMANDES_LN with(nolock)
        GROUP BY type
        "
    {:ok, %Tds.Result{columns: _, rows: rows}} = Perceptio.Repo.query(query, [])

    # Convert rows to list of maps with column names as keys
    rows
    |> Enum.map(fn [type, livrees, completees, pretes, encours, imprimees, afaire] ->
      %{
        type: type,
        livrees: livrees,
        completees: completees,
        pretes: pretes,
        encours: encours,
        imprimees: imprimees,
        afaire: afaire
      }
    end)
  end

  defp nb_commandes_ln_routes do
    # Replace this with your logic to retrieve the value
    query = "
        SELECT
        transport_category as type,
          0 as livrees,
          sum(iif(coalesce(statut,0) = 4,1,0)) as completees,
          sum(iif(coalesce(statut,0) = 3.5,1,0)) as pretes,
          sum(iif(coalesce(statut,0) = 3,1,0)) as encours,
          sum(iif(coalesce(statut,0) = 2,1,0)) as imprimees,
          sum(iif(coalesce(statut,0) = 1,1,0)) as afaire
      FROM ELEC_IND_COMMANDES_LN with(nolock)
      GROUP BY transport_category
        "
    {:ok, %Tds.Result{columns: _, rows: rows}} = Perceptio.Repo.query(query, [])

    # Convert rows to list of maps with column names as keys
    rows
    |> Enum.map(fn [type, livrees, completees, pretes, encours, imprimees, afaire] ->
      %{
        type: type,
        livrees: livrees,
        completees: completees,
        pretes: pretes,
        encours: encours,
        imprimees: imprimees,
        afaire: afaire
      }
    end)
  end

end
