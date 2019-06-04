defmodule Octicons.Storage do
  @moduledoc false

  require Logger

  @spec start_link :: Agent.on_start() | no_return
  def start_link do
    {:ok, data} = read_octicons_data()
    {:ok, metadata} = read_octicons_metadata()

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

  defp read_octicons_data do
    data_path = Path.expand("data.exs", priv_dir())
    {data, _binding} = Code.eval_file(data_path)

    {:ok, data}
  end

  defp read_octicons_metadata do
    metadata_path = Path.expand("metadata.exs", priv_dir())
    {data, _binding} = Code.eval_file(metadata_path)

    {:ok, data}
  end

  defp priv_dir do
    :code.priv_dir(:octicons)
  end
end
