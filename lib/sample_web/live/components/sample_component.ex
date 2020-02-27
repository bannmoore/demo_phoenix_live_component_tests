defmodule SampleWeb.Components.SampleComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(%{id: id} = assigns) do
    ~L"""
    <div id="<%= id %>">
      <button type="button" phx-click="hide_component" phx-window-keyup="hide_component" phx-target="#<%= id %>">Hide Me</button>
    </div>
    """
  end

  @impl true
  def handle_event("hide_component", _event_metadata, socket) do
    send(self(), :hide_component)

    {:noreply, socket}
  end
end
