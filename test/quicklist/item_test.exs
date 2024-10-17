defmodule Quicklist.TodoTest do
  use Quicklist.DataCase
  alias Quicklist.Todo

  describe "todos" do
    @valid_attrs %{title: "some text", completed: false}
    @update_attrs %{title: "some updated text", completed: true}
    @invalid_attrs %{title: nil}

    def todo_fixture(attrs \\ %{}) do
      {:ok, todo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Todo.create_todo()

      todo
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture(@valid_attrs)
      assert Todo.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      assert {:ok, %Todo{} = todo} = Todo.create_todo(@valid_attrs)
      assert todo.title == "some text"
      assert todo.completed == false

      inserted_todo = List.first(Todo.list_todos())
      assert inserted_todo.title == @valid_attrs.title
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todo.create_todo(@invalid_attrs)
    end

    test "list_todos/0 returns a list of todo items stored in the DB" do
      todo1 = todo_fixture()
      todo2 = todo_fixture()
      todos = Todo.list_todos()
      assert Enum.member?(todos, todo1)
      assert Enum.member?(todos, todo2)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{} = todo} = Todo.update_todo(todo, @update_attrs)
      assert todo.title == "some updated text"
      assert todo.completed == true
    end
  end
end
