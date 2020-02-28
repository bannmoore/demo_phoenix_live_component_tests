defmodule SampleWeb.Components.SampleComponentTest do
  use SampleWeb.ConnCase

  import Phoenix.LiveViewTest

  alias SampleWeb.Components.SampleComponent
  alias SampleWeb.Components.SampleComponentTest.TestLive

  describe "SampleComponent" do
    test "component has id attribute" do
      assert render_component(SampleComponent, %{id: "some-id"}) =~ "id=\"some-id\""
    end

    test "component has phx-click attribute" do
      assert render_component(SampleComponent, %{id: "test"}) =~ "phx-click=\"hide_component_click\""
    end

    test "component click to close" do
      {:ok, view, html} = live_isolated(build_conn(), TestLive, session: %{"pid" => Kernel.self()})

      assert 1 == html
      |> Floki.find("#sample-component")
      |> Enum.count()

      render_click([view, "sample-component"], "hide_component_click")

      assert_received(:hide_component)
    end

    test "component has phx-window-keyup attribute" do
      assert render_component(SampleComponent, %{id: "test"}) =~ "phx-window-keyup=\"hide_component_keyup\""
    end

    test "component esc key to close" do
      {:ok, view, html} = live_isolated(build_conn(), TestLive, session: %{"pid" => Kernel.self()})

      assert 1 == html
      |> Floki.find("#sample-component")
      |> Enum.count()

      render_keyup([view, "sample-component"], "hide_component_keyup", %{"key" => "Escape"})

      assert_received(:hide_component)
    end

    test "component enter key does not close" do
      {:ok, view, html} = live_isolated(build_conn(), TestLive, session: %{"pid" => Kernel.self()})

      assert 1 == html
      |> Floki.find("#sample-component")
      |> Enum.count()

      render_keyup([view, "sample-component"], "hide_component_keyup", %{"key" => "Enter"})

      refute_received(:hide_component)
    end
  end
end

defmodule SampleWeb.Components.SampleComponentTest.TestLive do
  use Phoenix.LiveView

  alias SampleWeb.Components.SampleComponent

  @impl true
  def mount(%{"pid" => test_pid}, socket) do
    {:ok, assign(socket, %{test_pid: test_pid})}
  end

  @impl true
  def render(%{socket: socket} = assigns) do
    ~L"""
    <%= live_component(socket, SampleComponent, id: "sample-component") %>
    """
  end

  @impl true
  def handle_info(event, %{assigns: %{test_pid: test_pid}} = socket) do
    send(test_pid, event)

    {:noreply, socket}
  end
end
