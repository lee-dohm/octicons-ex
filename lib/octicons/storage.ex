defmodule Octicons.Storage do
  @moduledoc false

  def start_link do
    data_path = Path.expand("../../priv/data.json", __DIR__)

    data =
      with {:ok, text} <- File.read(data_path),
           {:ok, data} <- Poison.decode(text),
           do: data

    Agent.start_link(fn -> data end, name: __MODULE__)
  end

  def get_data(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end
end
