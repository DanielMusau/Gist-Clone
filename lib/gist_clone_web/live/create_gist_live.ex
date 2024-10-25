defmodule GistCloneWeb.CreateGistLive do
  use GistCloneWeb, :live_view

  alias GistCloneWeb.GistFormComponent
  alias GistClone.{Gists, Gists.Gist}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
