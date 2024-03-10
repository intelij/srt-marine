defmodule MarineApp.Repo do
  use Ecto.Repo,
    otp_app: :marine_app,
    adapter: Ecto.Adapters.Postgres
end
