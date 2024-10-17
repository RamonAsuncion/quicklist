defmodule QuicklistWeb.PageLive do
  use QuicklistWeb, :live_view
  alias Quicklist.Todo

  @topic "live"

  @impl true
  def mount(_params, _session, socket) do
    # {:ok, socket}
    if connected?(socket), do: QuicklistWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, items: Todo.list_todos())}
  end

  #  id | title | completed |     inserted_at     |     updated_at
  # mix phx.gen.schema Todo todos title:string completed:boolean --timestamps
  @impl true
  def handle_event("create", %{"text" => text}, socket) do
    case Todo.create_todo(%{title: text}) do
      {:ok, _todo} ->
        # If creation is successful, update the items
        new_items = Todo.list_todos()
        socket = assign(socket, items: new_items)

        # Broadcast the update
        QuicklistWeb.Endpoint.broadcast_from(self(), @topic, "update", %{items: new_items})
        {:noreply, socket}

      {:error, _changeset} ->
        # TODO: Add errors messages here.
        {:noreply, assign(socket, error_message: "Failed to add todo.")}
    end
  end

  @impl true
  def handle_event("toggle", data, socket) do
    status = if Map.has_key?(data, "value"), do: true, else: false
    item = Todo.get_todo!(Map.get(data, "id"))
    Todo.update_todo(item, %{id: item.id, completed: status})
    socket = assign(socket, item: Todo.list_todos(), active: %Todo{})
    QuicklistWeb.Endpoint.broadcast(@topic, "update", socket.assigns)
    {:noreply, socket}
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

  # @impl true
  # def handle_event("clear_completed", _, socket) do
  #   updated_items = Enum.filter(socket.assigns.items, fn item -> !item.completed end)
  #   socket = assign(socket, items: updated_items)
  #   QuicklistWeb.Endpoint.broadcast(@topic, "update", socket.assigns)
  #   {:noreply, socket}
  # end

  @impl true
  def handle_info(%{event: "update", payload: %{items: items}}, socket) do
    {:noreply, assign(socket, items: items)}
  end

  @spec checked?(atom() | %{:completed => any(), optional(any()) => any()}) :: boolean()
  def checked?(item) do
    not is_nil(item.completed) and item.completed == true
  end

  def completed?(item) do
    if item.completed, do: "completed", else: ""
  end
end
