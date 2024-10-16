defmodule GistClone.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias GistClone.Accounts.User
  alias GistClone.Gists.Gist

  schema "comments" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :markup_text, :string

    belongs_to :user, User
    belongs_to :gist, Gist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:markup_text, :user_id, :gist_id])
    |> validate_required([:markup_text, :user_id, :gist_id])
  end
end
