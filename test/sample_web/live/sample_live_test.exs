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

      assert 0 == html
      |> Floki.find("#sample-component")
      |> Enum.count()
    end

    test "has phx-click property", %{conn: conn} do
      {:ok, _view, html} = live(conn, Routes.live_path(conn, SampleLive))

      assert html =~ "phx-click=\"show_component\""
    end

    test "click show component button", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.live_path(conn, SampleLive))

      assert 1 == view
      |> render_click("show_component")
      |> Floki.find("#sample-component")
      |> Enum.count()
    end

    test "receive hide_component message", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.live_path(conn, SampleLive))

      render_click(view, "show_component")

      # trying to render_click the child causes gen_server errors
      # render_click([view, "sample-component"], "hide_component_click")
      send(view.pid, :hide_component)

      assert 0 == view
      |> render()
      |> Floki.find("#sample-component")
      |> Enum.count()
    end
  end
end
