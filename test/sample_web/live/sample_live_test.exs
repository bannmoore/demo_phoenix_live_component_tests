defmodule SampleWeb.SampleLiveTest do
  use SampleWeb.ConnCase

  import Phoenix.LiveViewTest

  alias SampleWeb.SampleLive

  describe "SampleLive" do
    test "route works", %{conn: conn} do
      {:ok, view, html} = live(conn, Routes.live_path(conn, SampleLive))

      assert view.module == SampleLive
      assert html =~ "<h1>Example Time</h1>"
    end

    test "component is hidden on startup", %{conn: conn} do
      {:ok, _view, html} = live(conn, Routes.live_path(conn, SampleLive))

      refute html =~ "id=\"sample-component\""
    end

    test "has phx-click property", %{conn: conn} do
      {:ok, _view, html} = live(conn, Routes.live_path(conn, SampleLive))

      assert html =~ "phx-click=\"show_component\""
    end

    test "click show component button", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.live_path(conn, SampleLive))

      html = view
      |> render_click("show_component")

      assert html =~ "id=\"sample-component\""
    end

    test "receive hide_component message", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.live_path(conn, SampleLive))

      html = render_click(view, "show_component")

      assert html =~ "id=\"sample-component\""

      send(view.pid, :hide_component)
      hide_html = render(view)

      refute hide_html =~ "id=\"sample-component\""
    end

    # Can't test the boundary of events received from LiveComponent.
    test "integration with component", %{conn: conn} do
      {:ok, view, html} = live(conn, Routes.live_path(conn, SampleLive))

      refute html =~ "id=\"sample-component\""

      show_click_html = render_click(view, "show_component")

      assert show_click_html =~ "id=\"sample-component\""

      # this part doesn't work
      # hide_click_html = render_click([view, "sample-component"], "hide_component_click")

      # refute hide_click_html =~ "id=\"sample-component\""
    end
  end
end
