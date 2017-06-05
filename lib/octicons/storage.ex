defmodule Octicons.Storage do
  @moduledoc """
  Stores the Octicons data for easy access.
  """

  def start_link do
    data =
      with {:ok, text} <- File.read("./priv/data.json"),
           {:ok, data} <- Poison.decode(text),
           do: data

    Agent.start_link(fn -> data end, name: __MODULE__)
  end

  def get_data(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end
end
