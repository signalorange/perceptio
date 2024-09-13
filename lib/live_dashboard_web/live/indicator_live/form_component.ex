defmodule LiveDashboardWeb.IndicatorLive.FormComponent do
  use LiveDashboardWeb, :live_component

  alias LiveDashboard.Dashboard

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage indicator records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="indicator-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Indicator</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{indicator: indicator} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Dashboard.change_indicator(indicator))
     end)}
  end

  @impl true
  def handle_event("validate", %{"indicator" => indicator_params}, socket) do
    changeset = Dashboard.change_indicator(socket.assigns.indicator, indicator_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"indicator" => indicator_params}, socket) do
    save_indicator(socket, socket.assigns.action, indicator_params)
  end

  defp save_indicator(socket, :edit, indicator_params) do
    case Dashboard.update_indicator(socket.assigns.indicator, indicator_params) do
      {:ok, indicator} ->
        notify_parent({:saved, indicator})

        {:noreply,
         socket
         |> put_flash(:info, "Indicator updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_indicator(socket, :new, indicator_params) do
    case Dashboard.create_indicator(indicator_params) do
      {:ok, indicator} ->
        notify_parent({:saved, indicator})

        {:noreply,
         socket
         |> put_flash(:info, "Indicator created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
