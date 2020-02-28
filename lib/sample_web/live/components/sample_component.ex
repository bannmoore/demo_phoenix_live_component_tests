defmodule SampleWeb.Components.SampleComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(%{id: id} = assigns) do
    ~L"""
    <div id="<%= id %>">
      <button type="button" phx-click="hide_component_click" phx-window-keyup="hide_component_keyup" phx-target="#<%= id %>">Hide Me</button>
    </div>
    """
  end

  @impl true
  def handle_event("hide_component_click", _metadata, socket) do
    send(self(), :hide_component)

    {:noreply, socket}
  end

  def handle_event("hide_component_keyup", %{"key" => "Escape"}, socket) do
    send(self(), :hide_component)

    {:noreply, socket}
  end

  def handle_event("hide_component_keyup", _metadata, socket), do: {:noreply, socket}
end
