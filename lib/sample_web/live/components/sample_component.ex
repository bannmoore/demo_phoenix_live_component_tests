defmodule SampleWeb.Components.SampleComponent do
  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    {:ok, assign(socket, %{show_component: false})}
  end

  @impl true
  def render(%{id: id, trigger_html: trigger_html, show_component: show_component} = assigns) do
    ~L"""
    <div id="<%= id %>">
      <%= trigger_html %>

      <%= if show_component do %>
        <div id="visible" phx-hook="SampleHook">
          <button type="button" phx-click="hide_component_click" phx-window-keyup="hide_component_keyup" phx-target="#<%= id %>">Hide Me</button>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("show_component", _event_metadata, socket) do
    {:noreply, assign(socket, %{show_component: true})}
  end

  def handle_event("hide_component_click", _metadata, socket) do
    {:noreply, assign(socket, %{show_component: false})}
  end

  def handle_event("hide_component_keyup", %{"key" => "Escape"}, socket) do
    {:noreply, assign(socket, %{show_component: false})}
  end

  def handle_event("hide_component_keyup", _metadata, socket), do: {:noreply, socket}
end
