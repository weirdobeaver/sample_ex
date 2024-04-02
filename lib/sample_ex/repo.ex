defmodule SampleEx.Repo do
  use Ecto.Repo,
    otp_app: :sample_ex,
    adapter: Ecto.Adapters.Postgres
end
