defmodule Bancoh.Repo do
  use Ecto.Repo,
    otp_app: :bancoh,
    adapter: Ecto.Adapters.Postgres
end
