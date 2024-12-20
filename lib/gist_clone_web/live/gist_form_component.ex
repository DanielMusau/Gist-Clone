defmodule GistCloneWeb.GistFormComponent do
  use GistCloneWeb, :live_component
  import Phoenix.HTML.Form
  alias GistClone.{Gists, Gists.Gist}

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-submit="create" phx-change="validate" phx-target={@myself}>
        <div class="justify-center px-28 w-full space-y-4 mb-10">
          <%= hidden_input(@form, :id, value: @id) %>
          <.input
            field={@form[:description]}
            placeholder="Gist description..."
            autocomplete="off"
            phx-debounce="blur"
          />
          <div>
            <div class="flex p-2 items-center bg-dmDark rounded-t-md border">
              <div class="w-[300px] mb-2">
                <.input
                  field={@form[:name]}
                  placeholder="Filename including extension..."
                  autocomplete="off"
                  phx-debounce="blur"
                />
              </div>
            </div>
            <div id="gist-wrapper" class="flex w-full" phx-update="ignore">
              <textarea id="line-numbers" class="line-numbers rounded-bl-md" readonly>
        <%= "1\n" %>
      </textarea>
              <%= textarea(@form, :markup_text,
                id: "gist-textarea",
                phx_hook: "UpdateLineNumbers",
                class: "textarea w-full rounded-br-md",
                placeholder: "Insert code...",
                spellcheck: "false",
                autocomplete: "off",
                phx_debounce: "blur"
              ) %>
            </div>
          </div>
          <div class="flex justify-end">
            <%= if @id == :new do %>
              <.button class="create-button" phx-disable-with="Creating...">Create gist</.button>
            <% else %>
              <.button class="create-button" phx-disable-with="Updating...">Update gist</.button>
            <% end %>
          </div>
        </div>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    changeset =
      %Gist{}
      |> Gists.change_gist(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("create", %{"gist" => params}, socket) do
    if params["id"] == "new" do
      create_gist(params, socket)
    else
      update_gist(params, socket)
    end
  end

  defp create_gist(params, socket) do
    case Gists.create_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        socket = push_event(socket, "clear-textarea", %{})
        changeset = Gists.change_gist(%Gist{})
        socket = assign(socket, form: to_form(changeset))
        # Navigate to show the gist after successful creation
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[uuid: gist.uuid]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp update_gist(params, socket) do
    case Gists.update_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[uuid: gist.uuid]}")}

      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end
end
