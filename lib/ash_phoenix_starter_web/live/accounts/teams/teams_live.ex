defmodule AshPhoenixStarterWeb.Accounts.Teams.TeamsLive do
  use AshPhoenixStarterWeb, :live_view
  on_mount {AshPhoenixStarterWeb.LiveUserAuth, :live_user_required}

  def render(assigns) do
    ~H"""
    <Layouts.account_teams flash={@flash} current_user={@current_user} uri={@uri}>
      <Cinder.Table.table query={get_query(@current_user)}>
        <:col :let={team} field="Name" filter>{team.name}({team.domain})</:col>
        <:col :let={team}>
          <.button
            :if={team.domain !== @current_user.current_team}
            id={"team-#{team.id}"}
            phx-click={"change-to-#{team.domain}"}
          >
            <.icon name="hero-arrows-right-left" class="w-5 h-5" /> {gettext("Switch")}
          </.button>
        </:col>
      </Cinder.Table.table>
    </Layouts.account_teams>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("change-to-" <> team, _params, socket) do
    case switch_team_to(team, socket.assigns) do
      {:ok, _user} ->
        socket
        |> redirect(to: ~p"/accounts/teams")
        |> put_flash(:info, "Team changed")
        |> noreply()

      _error ->
        noreply(socket)
    end
  end

  defp switch_team_to(team, %{current_user: current_user}) do
    current_user
    |> Ash.Changeset.for_update(:switch_team_to, %{team: team}, authorize?: false)
    |> Ash.update()
  end

  defp get_query(%{id: user_id}) do
    require Ash.Query
    Ash.Query.filter(AshPhoenixStarter.Accounts.Team, users.id == ^user_id)
  end
end
