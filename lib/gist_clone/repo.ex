defmodule GistClone.Repo do
  use Ecto.Repo,
    otp_app: :gist_clone,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
