defmodule Octicons.Storage do
  @moduledoc false

  @spec start_link :: Agent.on_start() | no_return
  def start_link do
    {:ok, data} = read_priv_data("data.exs")
    {:ok, metadata} = read_priv_data("metadata.exs")

    Agent.start_link(fn -> %{data: data, metadata: metadata} end, name: __MODULE__)
  end

  @spec get_data(String.t()) :: map | nil
  def get_data(key) do
    Agent.get(__MODULE__, fn storage -> get_in(storage, [:data, key]) end)
  end

  @spec get_version :: String.t() | nil
  def get_version do
    Agent.get(__MODULE__, fn storage -> get_in(storage, [:metadata, "version"]) end)
  end

  defp read_priv_data(filename) do
    path = Path.expand(filename, :code.priv_dir(:octicons))
    {data, _binding} = Code.eval_file(path)

    {:ok, data}
  end
end
