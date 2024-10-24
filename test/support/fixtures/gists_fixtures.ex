defmodule GistClone.GistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GistClone.Gists` context.
  """

  @doc """
  Generate a gist.
  """
  def gist_fixture(attrs \\ %{}) do
    {:ok, gist} =
      attrs
      |> Enum.into(%{
        description: "some description",
        markup_text: "some markup_text",
        name: "some name",
        uuid: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> GistClone.Gists.create_gist()

    gist
  end

  @doc """
  Generate a saved_gist.
  """
  def saved_gist_fixture(attrs \\ %{}) do
    {:ok, saved_gist} =
      attrs
      |> Enum.into(%{
        uuid: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> GistClone.Gists.create_saved_gist()

    saved_gist
  end
end
