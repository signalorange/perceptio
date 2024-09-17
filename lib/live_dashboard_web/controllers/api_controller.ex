defmodule LiveDashboardWeb.APIController do
  use LiveDashboardWeb, :controller

  def nb_commandes_ln(conn, _params) do
    # Replace this with your logic to retrieve the value
    query = "SELECT
          (select
              count(*) as count
            from ve_livraisons_ln with(nolock)
            --inner join ve_livraisons with(nolock) on ve_livraisons.id = ve_livraisons_ln.ve_livraisons_id
            where  ve_livraisons_ln.created_date >= DATEADD(HOUR, 5, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
              and (
					ve_livraisons_ln.created_by = 'EXPEDITION1'
					or ve_livraisons_ln.created_by = 'EXPEDITION2'
					or ve_livraisons_ln.created_by = 'EXPEDITION3'
          or ve_livraisons_ln.created_by = 'VERIFICATION1'
          or ve_livraisons_ln.created_by = 'VERIFICATION2'
          or ve_livraisons_ln.created_by = 'SIMON.HOUMMAS'
          or ve_livraisons_ln.created_by = 'DONALD.GUITARD'
          or ve_livraisons_ln.created_by = 'MIGUEL.LACOMBE'
					)) as livrees,
          sum(iif(coalesce(statut,0) = 4,1,0)) as completees,
          sum(iif(coalesce(statut,0) = 3,1,0)) as encours,
          sum(iif(coalesce(statut,0) = 2,1,0)) as imprimees,
          sum(iif(coalesce(statut,0) = 1,1,0)) as afaire
        FROM ELEC_IND_COMMANDES_LN with(nolock)"
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
              count(*) as count
            from ve_livraisons_ln with(nolock)
            --inner join ve_livraisons with(nolock) on ve_livraisons.id = ve_livraisons_ln.ve_livraisons_id
            where  ve_livraisons_ln.created_date >= DATEADD(HOUR, 5, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
              and (
					ve_livraisons_ln.created_by = 'EXPEDITION1'
					or ve_livraisons_ln.created_by = 'EXPEDITION2'
					or ve_livraisons_ln.created_by = 'EXPEDITION3'
          or ve_livraisons_ln.created_by = 'VERIFICATION1'
          or ve_livraisons_ln.created_by = 'VERIFICATION2'
          or ve_livraisons_ln.created_by = 'SIMON.HOUMMAS'
          or ve_livraisons_ln.created_by = 'DONALD.GUITARD'
          or ve_livraisons_ln.created_by = 'MIGUEL.LACOMBE'
					)"
    value = fetch_query(query)
    json(conn, %{value: value})
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
