defmodule GistClone.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GistClone.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        markup_text: "some markup_text",
        uuid: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> GistClone.Comments.create_comment()

    comment
  end
end
