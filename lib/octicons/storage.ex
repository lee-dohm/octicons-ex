defmodule Octicons.Storage do
  @moduledoc false

  def start_link do
    {:ok, data} = read_octicons_data()
    {:ok, metadata} = read_octicons_metadata()

    Agent.start_link(fn -> %{data: data, metadata: metadata} end, name: __MODULE__)
  end

  def get_data(key) do
    Agent.get(__MODULE__, fn(storage) ->
      storage
      |> Map.get(:data)
      |> Map.get(key)
    end)
  end

  def get_version do
    Agent.get(__MODULE__, fn(storage) ->
      storage
      |> Map.get(:metadata)
      |> Map.get("version")
    end)
  end

  defp read_octicons_data do
    data_path = Path.expand("data.json", priv_dir())

    with {:ok, text} <- File.read(data_path),
         {:ok, data} <- Poison.decode(text)
    do
      {:ok, data}
    else
      err ->
        Logger.error("Error when reading Octicons data from priv directory: #{inspect(err)}")
        err
    end
  end

  defp read_octicons_metadata do
    metadata_path = Path.expand("package.json", priv_dir())

    with {:ok, text} <- File.read(metadata_path),
         {:ok, metadata} <- Poison.decode(text)
    do
      {:ok, metadata}
    else
      err ->
        Logger.error("Error when reading Octicons metadata from priv directory: #{inspect(err)}")
        err
    end
  end

  defp priv_dir do
    Path.join([File.cwd!(), "_build", Atom.to_string(Mix.env), "lib", "octicons", "priv"])
  end
end
