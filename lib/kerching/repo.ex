defmodule Kerching.Repo do
  use Ecto.Repo,
    otp_app: :kerching,
    adapter: Ecto.Adapters.Postgres
end
