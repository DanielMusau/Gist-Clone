defmodule GistClone.Gists.Gist do
  use Ecto.Schema
  import Ecto.Changeset

  alias GistClone.Accounts.User
  alias GistClone.Comments.Comment

  schema "gists" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :description, :string
    field :markup_text, :string
    field :name, :string

    belongs_to :user, User
    has_many :comments, Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gist, attrs) do
    gist
    |> cast(attrs, [:uuid, :name, :description, :markup_text, :user_id])
    |> validate_required([:uuid, :name, :description, :markup_text, :user_id])
  end
end
