defmodule SampleWeb.Components.SampleComponentTest do
  use SampleWeb.ConnCase

  import Phoenix.LiveViewTest

  alias SampleWeb.Components.SampleComponent
  alias SampleWeb.Components.SampleComponentTest.TestLive

  import Phoenix.HTML

  @component_id "sample-component"

  describe "SampleComponent" do
    test "component has id attribute" do
      {:ok, view, _html} = live_isolated(build_conn(), TestLive, session: %{"component_id"=> @component_id})

      assert render(view) =~ "id=\"#{@component_id}\""
    end

    test "component renders trigger_html" do
      {:ok, view, _html} = live_isolated(build_conn(), TestLive, session: %{"component_id" => @component_id})

      assert render(view) =~ "id=\"trigger\""
    end

    test "component has phx-click hide_component_click attribute" do
      {:ok, view, _html} = live_isolated(build_conn(), TestLive, session: %{"component_id" => @component_id})

      render_click([view, "sample-component"], "show_component")

      assert render(view) =~ "phx-click=\"hide_component_click\""
    end

    test "component click to close" do
      {:ok, view, _html} = live_isolated(build_conn(), TestLive, session: %{"component_id" => @component_id})

      render_click([view, "sample-component"], "show_component")

      assert 1 == view
      |> render()
      |> Floki.find("#visible")
      |> Enum.count()

      render_click([view, "sample-component"], "hide_component_click")

      assert 0 == view
      |> render()
      |> Floki.find("#visible")
      |> Enum.count()
    end

    test "component has phx-window-keyup attribute" do
      {:ok, view, _html} = live_isolated(build_conn(), TestLive, session: %{"component_id" => @component_id})

      render_click([view, "sample-component"], "show_component")

      assert render(view) =~ "phx-window-keyup=\"hide_component_keyup\""
    end

    test "component esc key to close" do
      {:ok, view, _html} = live_isolated(build_conn(), TestLive, session: %{"component_id" => @component_id})

      render_click([view, "sample-component"], "show_component")

      assert 1 == view
      |> render()
      |> Floki.find("#visible")
      |> Enum.count()

      render_keyup([view, "sample-component"], "hide_component_keyup", %{"key" => "Escape"})

      assert 0 == view
      |> render()
      |> Floki.find("#visible")
      |> Enum.count()
    end

    test "component enter key does not close" do
      {:ok, view, _html} = live_isolated(build_conn(), TestLive, session: %{"component_id" => @component_id})

      render_click([view, "sample-component"], "show_component")

      assert 1 == view
      |> render()
      |> Floki.find("#visible")
      |> Enum.count()

      render_keyup([view, "sample-component"], "hide_component_keyup", %{"key" => "Enter"})

      assert 1 == view
      |> render()
      |> Floki.find("#visible")
      |> Enum.count()
    end
  end
end

defmodule SampleWeb.Components.SampleComponentTest.TestLive do
  use Phoenix.LiveView

  alias SampleWeb.Components.SampleComponent

  import Phoenix.HTML

  @impl true
  def mount(%{"component_id" => component_id}, socket) do
    {:ok, assign(socket, %{component_id: component_id})}
  end

  @impl true
  def render(%{socket: socket, component_id: component_id} = assigns) do
    trigger_html = ~E"""
    <button id="trigger" type="button" phx-click="show_component" phx-target="#<%= @component_id %>">Show Component</button>
    """

    ~L"""
    <%= live_component(socket, SampleComponent, id: component_id, trigger_html: trigger_html) %>
    """
  end
end
