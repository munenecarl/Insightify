defmodule TrialInsightifyWeb.UserRegistrationLive do
  alias TrialInsightify.Accounts.Estates
  use TrialInsightifyWeb, :live_view
  import LiveSelect

  alias TrialInsightify.Accounts
  alias TrialInsightify.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
      <.simple_form
      for={@form}
      id="registration_form"
      phx-submit="save"
      phx-trigger-action={@trigger_submit}
      action={~p"/users/log_in?_action=registered"}
      method="post"
    >
      <.error :if={@check_errors}>
        Oops, something went wrong! Please check the errors below.
      </.error>

      <.input field={@form[:email]} type="email" placeholder="Email" required />

      <!--
      <.live_select
        field={@form[:estate]}
        placeholder="Select an estate"
        options={@estates}
        entry={:estate_name}
        value={:id}
      />
      -->
      <.input field={@form[:estate_name]} type="text" placeholder="estate" required />
      <.input field={@form[:password]} type="password" placeholder="Password" required />

      <:actions>
        <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})
    estates = Accounts.list_estates()

    socket =
      socket
      |> assign(:estates, estates)
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("live_select_change", %{"value" => selected_estate_id}, socket) do
    estates =
      socket.assigns.estates
      |> Enum.map(fn %{value: [id]} = estate ->
        if id == selected_estate_id do
          %{estate | selected: true}
        else
          %{estate | selected: false}
        end
      end)

    changeset = Ecto.Changeset.change(socket.assigns.form, estate_id: selected_estate_id)
    {:noreply, assign(socket, form: changeset, estates: estates)}
end

  # @impl true
  # def handle_event(
  #     "change",
  #     %{"my_form" => %{"city_search_text_input" => city_name, "city_search" => city_coords}},
  #     socket
  # ) do
  #   IO.puts("You selected city #{city_name} located at: #{city_coords}")
  #    {:noreply, socket}
  # end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
