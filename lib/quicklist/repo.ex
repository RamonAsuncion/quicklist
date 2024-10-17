defmodule Quicklist.Repo do
  use Ecto.Repo,
    otp_app: :quicklist,
    adapter: Ecto.Adapters.Postgres
end
