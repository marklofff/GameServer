defmodule GameServerWeb.RoomChannel do
  use Phoenix.Channel

  alias GameServer.Accounts
  alias GameServer.Accounts.User

  alias GameServer.Store.Player

  def join("room:lobby", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "authorized"}}
  end

  def handle_in("attack", %{"name" => name} = payload, socket) do
    
  end

  def handle_in("register", %{"name" => name} = payload, socket) do
    player = 
      case Accounts.get_user_by_name!(name) do
        %User{} = user ->
          user
        nil ->
          {:ok, user} = Accounts.create_user(payload)
          user
      end

    socket =
      socket
      |> assign(:user, player)

    Player.put(player)

    IO.puts "Register"
    IO.inspect payload

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    push(socket, "new_msg", %{list: "hello"})
    {:noreply, socket}
  end

  defp format_state(state) do
    for {key, val} <- state, into: %{}, do: {String.to_atom(key), val}
  end
end
