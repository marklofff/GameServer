defmodule GameServer.Store.Boss do
  @moduledoc """
  Store the state of the game players.
  """

  use Agent

  @doc """
  Start Store.
  """
  @spec start_link(Map.t()) :: :ok
  def start_link(state \\ %{}) do
    Agent.start_link(fn -> state end, name: __MODULE__)
  end

  @doc """
  Return all game players.
  """
  @spec all() :: List.t()
  def all do
    Agent.get(__MODULE__, fn players ->
      players
      |> Map.to_list()
      |> Enum.map(&elem(&1, 1))
    end)
  end

  @doc """
  Update or insert a player.
  """
  @spec put(Map.t()) :: :ok
  def put(player) do
    Agent.update(__MODULE__, &Map.put(&1, player.id, player))
  end

  @doc """
    ボスのヘルスを更新する
  """
  @spec update_health(Map.t()) :: :ok
  def update_health(value) do
    current_state = Agent.get(__MODULE__, &(&1))
    current_state = Map.update!(current_state, :health, &(&1 - value))

    Agent.update(__MODULE__, fn state -> current_state end)
  end

  @doc """
  Get player by id.
  """
  @spec get() :: Map.t()
  def get() do
   Agent.get(__MODULE__, & &1)
  end

  @doc """
  Delete player by id.
  """
  @spec delete(String.t()) :: :ok
  def delete(player_id) do
    Agent.update(__MODULE__, &Map.delete(&1, player_id))
  end

  @doc """
  Clean players.
  """
  @spec clean() :: :ok
  def clean do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end

  defp default_attrs(player_id) do
    %{id: player_id, nickname: player_id}
  end
end
