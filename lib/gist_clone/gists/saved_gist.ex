defmodule GistClone.Gists.SavedGist do
  use Ecto.Schema
  import Ecto.Changeset

  alias GistClone.Accounts.User
  alias GistClone.Gists.Gist

  schema "saved_gists" do
    field :uuid, Ecto.UUID, autogenerate: true

    belongs_to :user, User
    belongs_to :gist, Gist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(saved_gist, attrs) do
    saved_gist
    |> cast(attrs, [:uuid, :user_id, :gist_id])
    |> validate_required([:uuid, :user_id, :gist_id])
  end
end
