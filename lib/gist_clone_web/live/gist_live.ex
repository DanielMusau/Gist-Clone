defmodule GistCloneWeb.GistLive do
  use GistCloneWeb, :live_view

  alias GistClone.Gists
  alias GistCloneWeb.{GistFormComponent, Utilities.DateFormat}

  def mount(%{"uuid" => uuid}, _session, socket) do
    gist = Gists.get_gist_by(%{uuid: uuid})

    gist = Map.put(gist, :rel_time, DateFormat.get_relative_time(gist.inserted_at))
    {:ok, assign(socket, gist: gist)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Gists.delete_gist(socket.assigns.current_user, id) do
      {:ok, _gist} ->
        socket = put_flash(socket, :info, "Gist deleted successfully")
        {:noreply, push_navigate(socket, to: ~p"/create")}

      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end
end
