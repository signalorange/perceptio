defmodule PerceptioWeb.IndicatorLiveTest do
  use PerceptioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Perceptio.DashboardFixtures

  @create_attrs %{description: "some description"}
  @update_attrs %{description: "some updated description"}
  @invalid_attrs %{description: nil}

  defp create_indicator(_) do
    indicator = indicator_fixture()
    %{indicator: indicator}
  end

  describe "Index" do
    setup [:create_indicator]

    test "lists all indicators", %{conn: conn, indicator: indicator} do
      {:ok, _index_live, html} = live(conn, ~p"/indicators")

      assert html =~ "Listing Indicators"
      assert html =~ indicator.description
    end

    test "saves new indicator", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/indicators")

      assert index_live |> element("a", "New Indicator") |> render_click() =~
               "New Indicator"

      assert_patch(index_live, ~p"/indicators/new")

      assert index_live
             |> form("#indicator-form", indicator: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#indicator-form", indicator: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/indicators")

      html = render(index_live)
      assert html =~ "Indicator created successfully"
      assert html =~ "some description"
    end

    test "updates indicator in listing", %{conn: conn, indicator: indicator} do
      {:ok, index_live, _html} = live(conn, ~p"/indicators")

      assert index_live |> element("#indicators-#{indicator.id} a", "Edit") |> render_click() =~
               "Edit Indicator"

      assert_patch(index_live, ~p"/indicators/#{indicator}/edit")

      assert index_live
             |> form("#indicator-form", indicator: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#indicator-form", indicator: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/indicators")

      html = render(index_live)
      assert html =~ "Indicator updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes indicator in listing", %{conn: conn, indicator: indicator} do
      {:ok, index_live, _html} = live(conn, ~p"/indicators")

      assert index_live |> element("#indicators-#{indicator.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#indicators-#{indicator.id}")
    end
  end

  describe "Show" do
    setup [:create_indicator]

    test "displays indicator", %{conn: conn, indicator: indicator} do
      {:ok, _show_live, html} = live(conn, ~p"/indicators/#{indicator}")

      assert html =~ "Show Indicator"
      assert html =~ indicator.description
    end

    test "updates indicator within modal", %{conn: conn, indicator: indicator} do
      {:ok, show_live, _html} = live(conn, ~p"/indicators/#{indicator}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Indicator"

      assert_patch(show_live, ~p"/indicators/#{indicator}/show/edit")

      assert show_live
             |> form("#indicator-form", indicator: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#indicator-form", indicator: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/indicators/#{indicator}")

      html = render(show_live)
      assert html =~ "Indicator updated successfully"
      assert html =~ "some updated description"
    end
  end
end
