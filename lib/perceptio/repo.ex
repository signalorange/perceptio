defmodule Perceptio.Repo do
  use Ecto.Repo,
    otp_app: :perceptio,
    adapter: Ecto.Adapters.Tds
end
