defmodule GistCloneWeb.AllGistsLive do
  use GistCloneWeb, :live_view

  alias GistClone.Gists

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    gists = Gists.list_gists()

    socket = assign(socket, :gists, gists)

    {:noreply, socket}
  end

  def gist(assigns) do
    ~H"""
    <div class="text-white">
      <%= @current_user.email %> / <%= @gist.name %>
    </div>
    <div class="text-white">
      <%= @gist.inserted_at %>
    </div>
    <div class="text-white">
      <%= @gist.description %>
    </div>
    <div class="text-white">
      <%= @gist.markup_text %>
    </div>
    """
  end
end
