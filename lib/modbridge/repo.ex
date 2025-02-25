defmodule Modbridge.Repo do
  use Ecto.Repo,
    otp_app: :modbridge,
    adapter: Ecto.Adapters.Postgres
end
