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

    test "renders trigger_html with correct id", %{conn: conn} do
      {:ok, _view, html} = live(conn, Routes.live_path(conn, SampleLive))

      assert html =~ "id=\"sample-component\""
      assert html =~ "phx-click=\"show_component\""
      assert html =~ "phx-target=\"#sample-component\""
    end

    test "integration with component", %{conn: conn} do
      {:ok, view, html} = live(conn, Routes.live_path(conn, SampleLive))

      refute html =~ "id=\"visible\""

      show_click_html = render_click([view, "sample-component"], "show_component")

      assert show_click_html =~ "id=\"visible\""

      hide_click_html = render_click([view, "sample-component"], "hide_component_click")

      refute hide_click_html =~ "id=\"visible\""
    end
  end
end
