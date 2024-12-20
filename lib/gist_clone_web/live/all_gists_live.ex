defmodule GistCloneWeb.AllGistsLive do
  use GistCloneWeb, :live_view

  alias GistClone.Gists
  alias GistCloneWeb.Utilities.DateFormat

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"page" => page}, _uri, socket) do
    assigns = get_and_assign_page(page)
    {:noreply, assign(socket, assigns)}
  end

  def handle_params(_params, _uri, socket) do
    assigns = get_and_assign_page(nil)
    {:noreply, assign(socket, assigns)}
  end

  def get_and_assign_page(page_num) do
    IO.inspect(page_num, label: "page_num")

    %{
      entries: entries,
      page_number: page_num,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Gists.return_paginated_gists(%{page: page_num})

    [
      gists: entries,
      page_number: page_num,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    ]
  end

  def gist(assigns) do
    ~H"""
    <div class="justify-center px-28 w-full mb-20">
      <div class="flex justify-between mb-4">
        <div class="flex items-center">
          <img
            src="/images/user-image.svg"
            alt="Profile Image"
            class="round-image-padding w-8 h-8 mb-7"
          />
          <div class="flex flex-col ml-4">
            <div class="font-bold text-base text-dmLavender">
              <%= @gist.user.username %> <span class="text-white"> / </span>
              <a
                href="#"
                phx-click="navigate_to_gist"
                phx-value-id={@gist.id}
                class="text-dmLavender font-bold hover:border-b-2 hover:border-dmLavender"
              >
                <%= @gist.name %>
              </a>
            </div>
            <div class="text-white font-bold text-lg">
              <%= "Created #{DateFormat.get_relative_time(@gist.updated_at)}" %>
            </div>
            <div class="text-white text-sm">
              <%= @gist.description %>
            </div>
          </div>
        </div>
        <div class="flex items-center">
          <img src="/images/comment.svg" alt="Comment Count" class="w-6 h-6" />
          <span class="text-white h-6 px-1">0</span>
          <img src="/images/BookmarkOutline.svg" alt="Bookmark Count" class="w-6 h-6" />
          <span class="text-white h-6 px-1">0</span>
        </div>
      </div>
      <div id="gist-wrapper" class="flex w-full">
        <textarea id="syntax-numbers" class="syntax-numbers rounded-bl-md rounded-tl-md" readonly></textarea>
        <div
          id="highlight"
          class="syntax-area w-full rounded-br-md rounded-tr-md"
          phx-hook="Highlight"
          data-name={@gist.name}
        >
          <pre><code class="language-elixir">
    <%= get_preview_text(@gist) %>
    </code></pre>
        </div>
      </div>
    </div>
    """
  end

  defp get_preview_text(gist) when not is_nil(gist.markup_text) do
    lines = gist.markup_text |> String.split("\n")

    if length(lines) > 10 do
      (Enum.take(lines, 9) ++ ["..."]) |> Enum.join("\n")
    else
      gist.markup_text
    end
  end

  defp get_preview_text(_gist), do: ""

  def handle_event("navigate_to_gist", %{"id" => gist_id}, socket) do
    gist = Gists.get_gist!(gist_id)
    {:noreply, push_navigate(socket, to: ~p"/gist?#{[uuid: gist.uuid]}")}
  end

  def handle_event("nav", %{"page" => page}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/all?page=#{page}")}
  end
end
