defmodule GistClone.GistsTest do
  use GistClone.DataCase

  alias GistClone.Gists

  describe "gists" do
    alias GistClone.Gists.Gist

    import GistClone.GistsFixtures

    @invalid_attrs %{description: nil, markup_text: nil, name: nil, uuid: nil}

    test "list_gists/0 returns all gists" do
      gist = gist_fixture()
      assert Gists.list_gists() == [gist]
    end

    test "get_gist!/1 returns the gist with given id" do
      gist = gist_fixture()
      assert Gists.get_gist!(gist.id) == gist
    end

    test "create_gist/1 with valid data creates a gist" do
      valid_attrs = %{
        description: "some description",
        markup_text: "some markup_text",
        name: "some name",
        uuid: "7488a646-e31f-11e4-aace-600308960662"
      }

      assert {:ok, %Gist{} = gist} = Gists.create_gist(valid_attrs)
      assert gist.description == "some description"
      assert gist.markup_text == "some markup_text"
      assert gist.name == "some name"
      assert gist.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_gist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gists.create_gist(@invalid_attrs)
    end

    test "update_gist/2 with valid data updates the gist" do
      gist = gist_fixture()

      update_attrs = %{
        description: "some updated description",
        markup_text: "some updated markup_text",
        name: "some updated name",
        uuid: "7488a646-e31f-11e4-aace-600308960668"
      }

      assert {:ok, %Gist{} = gist} = Gists.update_gist(gist, update_attrs)
      assert gist.description == "some updated description"
      assert gist.markup_text == "some updated markup_text"
      assert gist.name == "some updated name"
      assert gist.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_gist/2 with invalid data returns error changeset" do
      gist = gist_fixture()
      assert {:error, %Ecto.Changeset{}} = Gists.update_gist(gist, @invalid_attrs)
      assert gist == Gists.get_gist!(gist.id)
    end

    test "delete_gist/1 deletes the gist" do
      gist = gist_fixture()
      assert {:ok, %Gist{}} = Gists.delete_gist(gist)
      assert_raise Ecto.NoResultsError, fn -> Gists.get_gist!(gist.id) end
    end

    test "change_gist/1 returns a gist changeset" do
      gist = gist_fixture()
      assert %Ecto.Changeset{} = Gists.change_gist(gist)
    end
  end

  describe "saved_gists" do
    alias GistClone.Gists.SavedGist

    import GistClone.GistsFixtures

    @invalid_attrs %{uuid: nil}

    test "list_saved_gists/0 returns all saved_gists" do
      saved_gist = saved_gist_fixture()
      assert Gists.list_saved_gists() == [saved_gist]
    end

    test "get_saved_gist!/1 returns the saved_gist with given id" do
      saved_gist = saved_gist_fixture()
      assert Gists.get_saved_gist!(saved_gist.id) == saved_gist
    end

    test "create_saved_gist/1 with valid data creates a saved_gist" do
      valid_attrs = %{uuid: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %SavedGist{} = saved_gist} = Gists.create_saved_gist(valid_attrs)
      assert saved_gist.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_saved_gist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gists.create_saved_gist(@invalid_attrs)
    end

    test "update_saved_gist/2 with valid data updates the saved_gist" do
      saved_gist = saved_gist_fixture()
      update_attrs = %{uuid: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %SavedGist{} = saved_gist} = Gists.update_saved_gist(saved_gist, update_attrs)
      assert saved_gist.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_saved_gist/2 with invalid data returns error changeset" do
      saved_gist = saved_gist_fixture()
      assert {:error, %Ecto.Changeset{}} = Gists.update_saved_gist(saved_gist, @invalid_attrs)
      assert saved_gist == Gists.get_saved_gist!(saved_gist.id)
    end

    test "delete_saved_gist/1 deletes the saved_gist" do
      saved_gist = saved_gist_fixture()
      assert {:ok, %SavedGist{}} = Gists.delete_saved_gist(saved_gist)
      assert_raise Ecto.NoResultsError, fn -> Gists.get_saved_gist!(saved_gist.id) end
    end

    test "change_saved_gist/1 returns a saved_gist changeset" do
      saved_gist = saved_gist_fixture()
      assert %Ecto.Changeset{} = Gists.change_saved_gist(saved_gist)
    end
  end
end
