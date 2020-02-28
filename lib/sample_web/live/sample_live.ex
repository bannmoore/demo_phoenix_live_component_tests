defmodule SampleWeb.SampleLive do
  use Phoenix.LiveView

  alias SampleWeb.Components.SampleComponent

  import Phoenix.HTML

  @impl true
  def render(%{socket: socket} = assigns) do
    component_id = "sample-component"

    trigger_html = ~E"""
    <button type="button" phx-click="show_component" phx-target="#<%= component_id %>">Show Component</button>
    """

    ~L"""
    <h1>Example Time</h1>

    <%= live_component(socket, SampleComponent, id: component_id, trigger_html: trigger_html) %>
    """
  end
end

