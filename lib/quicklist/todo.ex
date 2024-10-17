defmodule Quicklist.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Quicklist.Repo
  alias __MODULE__

  schema "todos" do
    field :title, :string
    field :completed, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :completed])
    |> validate_required([:title])
  end

  @doc """
  Creates a new todo.

  ## Examples

      iex> create_todo(%{title: "My new todo"})
      {:ok, %Todo{id: 1, title: "My new todo", completed: false}}

      iex> create_todo(%{title: nil})
      {:error, %Ecto.Changeset{...}}
  """
  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a todo.

  ## Examples

    iex> delete_todo(1)
    {:ok, %Todo{id: 1, title: "My todo", completed: false}}

    iex> delete_todo(999)
    ** (Ecto.NoResultsError)
  """
  def delete_todo(id) do
    get_todo!(id)
    |> Repo.delete()
  end

  @doc """
  Retrieves a todo by ID.

  ## Examples

      iex> get_todo!(1)
      %Todo{id: 1, title: "My new todo", completed: false}

      iex> get_todo!(999)
      ** (Ecto.NoResultsError)
  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Updates an existing todo.

  ## Examples

      iex> todo = get_todo!(1)
      iex> update_todo(todo, %{completed: true})
      {:ok, %Todo{id: 1, title: "My new todo", completed: true}}

      iex> update_todo(todo, %{title: nil})
      {:error, %Ecto.Changeset{...}}
  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Lists all todos.

  ## Examples

      iex> list_todos()
      [%Todo{id: 1, title: "My new todo", completed: false}, ...]
  """
  def list_todos do
    Repo.all(Todo)
  end
end
