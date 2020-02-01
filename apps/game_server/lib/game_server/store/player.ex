defmodule GameServer.Store.Player do
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
  Get player by id.
  """
  @spec get(String.t()) :: Map.t()
  def get(player_id) do
    Agent.get(__MODULE__, &Map.get(&1, player_id, default_attrs(player_id)))
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
