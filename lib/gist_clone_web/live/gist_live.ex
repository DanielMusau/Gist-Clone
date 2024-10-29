defmodule GistCloneWeb.GistLive do
  use GistCloneWeb, :live_view

  alias GistClone.Gists
  alias GistCloneWeb.GistFormComponent

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(id)

    {:ok, rel_time} = Timex.format(gist.inserted_at, "{relative}", :relative)
    gist = Map.put(gist, :rel_time, rel_time)
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
