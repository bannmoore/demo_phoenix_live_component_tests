defmodule SampleWeb.Components.SampleComponentTest do
  use SampleWeb.ConnCase

  import Phoenix.LiveViewTest

  alias SampleWeb.Components.SampleComponentTest.TestLive

  # if one of these tests is commented out, they each pass individually.
  test "component click to close", %{conn: conn} do
    {:ok, view, _html} = live_isolated(conn, TestLive)

    assert 1 == view
    |> render()
    |> Floki.find("#sample-component")
    |> Enum.count()

    render_click([view, "sample-component"], "hide_component")

    assert 0 == view
    |> render()
    |> Floki.find("#sample-component")
    |> Enum.count()
  end

  test "component esc key to close", %{conn: conn} do
    {:ok, view, _html} = live_isolated(conn, TestLive)

    assert 1 == view
    |> render()
    |> Floki.find("#sample-component")
    |> Enum.count()

    render_keyup([view, "sample-component"], "hide_component", :Escape)

    assert 0 == view
    |> render()
    |> Floki.find("#sample-component")
    |> Enum.count()
  end
end

defmodule SampleWeb.Components.SampleComponentTest.TestLive do
  use Phoenix.LiveView

  alias SampleWeb.Components.SampleComponent

  @impl true
  def mount(_assigns, socket) do
    {:ok, assign(socket, %{show_component: true})}
  end

  @impl true
  def render(%{socket: socket, show_component: show_component} = assigns) do
    ~L"""
    <%= if show_component do %>
      <%= live_component(socket, SampleComponent, id: "sample-component") %>
    <% end %>
    """
  end

  @impl true
  def handle_info(:hide_component, socket) do
    {:noreply, assign(socket, %{show_component: false})}
  end
end
