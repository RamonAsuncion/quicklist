defmodule QuicklistWeb.PageLive do
  use QuicklistWeb, :live_view
  alias Quicklist.Todo

  @topic "live"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: QuicklistWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, items: Todo.list_todos())}
  end

  @impl true
  def handle_event("create", %{"text" => text}, socket) do
    case Todo.create_todo(%{title: text}) do
      {:ok, _todo} ->
        new_items = Todo.list_todos()
        socket = assign(socket, items: new_items)
        QuicklistWeb.Endpoint.broadcast_from(self(), @topic, "update", %{items: new_items})
        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, assign(socket, error_message: "Failed to add todo.")}
    end
  end

  @impl true
  def handle_event("toggle", %{"id" => id}, socket) do
    item = Todo.get_todo!(id)
    new_status = not item.completed
    Todo.update_todo(item, %{completed: new_status})

    new_items = Todo.list_todos()
    QuicklistWeb.Endpoint.broadcast(@topic, "update", %{items: new_items})

    {:noreply, assign(socket, items: new_items)}
  end

  @impl true
  def handle_event("clear_completed", _params, socket) do
    Todo.clear_completed_todos()
    new_items = Todo.list_todos()
    {:noreply, assign(socket, items: new_items)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Todo.delete_todo(id) do
      {:ok, _deleted_todo} ->
        updated_items = Todo.list_todos()
        socket = assign(socket, items: updated_items)
        QuicklistWeb.Endpoint.broadcast(@topic, "update", socket.assigns)
        {:noreply, socket}

      {:error, _reason} ->
        {:noreply, assign(socket, error_message: "Failed to delete todo.")}
    end
  end

  @impl true
  def handle_info(%{event: "update", payload: %{items: items}}, socket) do
    {:noreply, assign(socket, items: items)}
  end
end
