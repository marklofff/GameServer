defmodule GameServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias GameServer.Store.Player

  def start(_type, _args) do
    children = [
      GameServer.Repo,
      {Player, %{}}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: GameServer.Supervisor)
  end
end
