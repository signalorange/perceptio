defmodule LiveDashboardWeb.APIController do
  use LiveDashboardWeb, :controller

  def nb_commandes_ln(conn, _params) do
    # Replace this with your logic to retrieve the value
    query = "with livrees as (
select
    id
from ve_livraisons_ln with(nolock)
--inner join ve_livraisons with(nolock) on ve_livraisons.id = ve_livraisons_ln.ve_livraisons_id
where ve_livraisons_ln.created_by in ('EXPEDITION1','EXPEDITION2','EXPEDITION3','VERIFICATION1','VERIFICATION2','SIMON.HOUMMAS','DONALD.GUITARD','MIGUEL.LACOMBE')
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
          coalesce(sum(iif(coalesce(statut,0) = 3,1,0)),0) as encours,
          coalesce(sum(iif(coalesce(statut,0) = 2,1,0)),0) as imprimees,
          coalesce(sum(iif(coalesce(statut,0) = 1,1,0)),0) as afaire
        FROM ELEC_IND_COMMANDES_LN with(nolock)
		)
select *, (livrees+completees+encours+imprimees+afaire) as total
from somme"
    value = fetch_query_total(query)
    json_data = convert_tds_result_to_json(value)
    json(conn, json_data)
  end

  def nb_commandes_ln_types(conn, _params) do
    # Replace this with your logic to retrieve the value
    query = "
        SELECT
          type as type,
          0 as livrees,
          sum(iif(coalesce(statut,0) = 4,1,0)) as completees,
          sum(iif(coalesce(statut,0) = 3,1,0)) as encours,
          sum(iif(coalesce(statut,0) = 2,1,0)) as imprimees,
          sum(iif(coalesce(statut,0) = 1,1,0)) as afaire
        FROM ELEC_IND_COMMANDES_LN with(nolock)
        GROUP BY type
        "
    value = fetch_query_total(query)
    json_data = convert_tds_result_to_json(value)
    json(conn, json_data)
  end

  def nb_commandes_ln_routes(conn, _params) do
    # Replace this with your logic to retrieve the value
    query = "

      SELECT
        transport_category as type,
          0 as livrees,
          sum(iif(coalesce(statut,0) = 4,1,0)) as completees,
          sum(iif(coalesce(statut,0) = 3,1,0)) as encours,
          sum(iif(coalesce(statut,0) = 2,1,0)) as imprimees,
          sum(iif(coalesce(statut,0) = 1,1,0)) as afaire
      FROM ELEC_IND_COMMANDES_LN with(nolock)
      GROUP BY transport_category"
    value = fetch_query_total(query)
    json_data = convert_tds_result_to_json(value)
    json(conn, json_data)
  end

  def nb_commandes_ln_cable(conn, _params) do
    # Replace this with your logic to retrieve the value
    query = "SELECT count(*) as count
            from ELEC_IND_COMMANDES_LN WITH(NOLOCK)
            WHERE isCable = 1"
    value = fetch_query(query)
    json(conn, %{value: value})
  end

  def nb_commandes_ln_ext(conn, _params) do
    # Replace this with your logic to retrieve the value
    query = "SELECT count(*) as count
            from ELEC_IND_COMMANDES_LN WITH(NOLOCK)
            WHERE isExt = 1"
    value = fetch_query(query)
    json(conn, %{value: value})
  end

  def nb_commandes_ln_printed(conn, _params) do
    # Replace this with your logic to retrieve the value
    query = "SELECT count(*) as count
            from ELEC_IND_COMMANDES_LN WITH(NOLOCK)
            WHERE statut = 2"
    value = fetch_query(query)
    json(conn, %{value: value})
  end

  def nb_commandes_ln_afaire(conn, _params) do
    # Replace this with your logic to retrieve the value
    query = "SELECT count(*) as count
            from ELEC_IND_COMMANDES_LN WITH(NOLOCK)
            WHERE statut = 1"
    value = fetch_query(query)
    json(conn, %{value: value})
  end

  def nb_commandes_ln_encours(conn, _params) do
    # Replace this with your logic to retrieve the value
    query = "SELECT count(*) as count
            from ELEC_IND_COMMANDES_LN WITH(NOLOCK)
            WHERE statut = 3"
    value = fetch_query(query)
    json(conn, %{value: value})
  end

  def nb_commandes_ln_faites(conn, _params) do
    # Replace this with your logic to retrieve the value
    query = "SELECT count(*) as count
            from ELEC_IND_COMMANDES_LN WITH(NOLOCK)
            WHERE statut = 4"
    value = fetch_query(query)
    json(conn, %{value: value})
  end

  def nb_commandes_ln_livrees(conn, _params) do
    # Replace this with your logic to retrieve the value
    query = "select
    count(id) as count
from ve_livraisons_ln with(nolock)
--inner join ve_livraisons with(nolock) on ve_livraisons.id = ve_livraisons_ln.ve_livraisons_id
where ve_livraisons_ln.created_by in ('EXPEDITION1','EXPEDITION2','EXPEDITION3','VERIFICATION1','VERIFICATION2','SIMON.HOUMMAS','DONALD.GUITARD','MIGUEL.LACOMBE')
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
		)))		"
    value = fetch_query(query)
    json(conn, %{value: value})
  end

  def nb_commandes_ln_jour(conn, _params) do
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
    value = fetch_query_total(query)
    json_data = convert_tds_result_to_json(value)
    json(conn, json_data)
  end

  def nb_commandes_ln_semaine(conn, _params) do
    # Replace this with your logic to retrieve the value
    query = "select
    coalesce(avg(livrees),0) as livrees,
    coalesce(avg(completees),0) as completees,
    coalesce(avg(encours),0) as encours,
    coalesce(avg(imprimees),0) as imprimees,
    coalesce(avg(afaire),0) as afaire,
    coalesce(avg(livrees),0)+coalesce(avg(completees),0)+coalesce(avg(encours),0)+coalesce(avg(imprimees),0)+coalesce(avg(afaire),0) as total,
    format(dateAjout, 'HH') as heure
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
group by format(dateAjout, 'HH')"
    value = fetch_query_total(query)
    json_data = convert_tds_result_to_json(value)
    json(conn, json_data)
  end

  defp fetch_query(query) do
    {:ok, result} = LiveDashboard.Repo.query(query, [])
    case result.rows do
      [[count]] -> count
      _ ->  0
    end
  end
  defp fetch_query_total(query) do
    LiveDashboard.Repo.query(query, [])
  end

  def convert_tds_result_to_json({:ok, %Tds.Result{columns: columns, rows: rows}}) do
    # Convert each row into a map with the corresponding column names
    data =
      Enum.map(rows, fn row ->
        Enum.zip(columns, row) |> Enum.into(%{})
      end)

    # Encode the data to JSON
    data
  end

  def convert_tds_result_to_json({:error, reason}) do
    # Handle error, return appropriate JSON response
    Jason.encode!(%{error: reason})
  end

end
