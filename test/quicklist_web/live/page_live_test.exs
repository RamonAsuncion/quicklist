defmodule QuicklistWeb.PageLiveTest do
  use QuicklistWeb.ConnCase
  import Phoenix.LiveViewTest
  alias Quicklist.Todo

  # test "disconnected and connected mount", %{conn: conn} do
  #   {:ok, page_live, disconnected_html} = live(conn, "/")
  #   assert disconnected_html =~ "Todo"
  #   assert render(page_live) =~ "What needs to be done"
  # end

  test "connect and create a todo item", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    assert render_submit(view, :create, %{"text" => "Learn Elixir"}) =~ "Learn Elixir"
  end

  test "toggle an item", %{conn: conn} do
    {:ok, item} = Todo.create_todo(%{"title" => "Adding an item!"})
    assert item.completed == false

    {:ok, view, _html} = live(conn, "/")
    assert render_click(view, :toggle, %{"id" => item.id, "value" => 1}) =~ "completed"

    updated_item = Todo.get_todo!(item.id)
    assert updated_item.completed == true
  end

  test "delete an item", %{conn: conn} do
    {:ok, item} = Todo.create_todo(%{"title" => "Learn Elixir"})
    assert item.completed == false

    {:ok, view, _html} = live(conn, "/")
    assert render_click(view, :delete, %{"id" => item.id})

    assert_raise Ecto.NoResultsError, fn ->
      Todo.get_todo!(item.id)
    end
  end
end
