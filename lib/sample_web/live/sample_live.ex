defmodule SampleWeb.SampleLive do
  use Phoenix.LiveView

  alias SampleWeb.Components.SampleComponent

  @impl true
  def mount(assigns, socket) do
    {:ok, assign(socket, %{show_component: false})}
  end

  @impl true
  def render(%{socket: socket, show_component: show_component} = assigns) do
    ~L"""
    <h1>Example Time</h1>

    <button type="button" phx-click="show_component">Show Component</button>
    <%= if show_component do %>
      <%= live_component(socket, SampleComponent, id: "sample-component") %>
    <% end %>
    """
  end

  @impl true
  def handle_event("show_component", _event_metadata, socket) do
    {:noreply, assign(socket, %{show_component: true})}
  end

  @impl true
  def handle_info(:hide_component, socket) do
    {:noreply, assign(socket, %{show_component: false})}
  end
end

