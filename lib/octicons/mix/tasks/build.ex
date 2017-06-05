defmodule Mix.Tasks.Octicons.Build do
  use Mix.Task

  @shortdoc "Pull down the necessary files and copy to their rightful places"

  def run(_) do
    base_dir = System.cwd()
    priv_dir = Path.join(base_dir, "priv")

    {_, 0} = System.cmd("npm", ["install"])
    ensure_directory(priv_dir)
    {:ok, _} = File.copy(Path.join([base_dir, "node_modules", "octicons", "build", "data.json"]), Path.join(priv_dir, "data.json"))
  end

  defp ensure_directory(path) do
    case File.mkdir(path) do
      :ok -> nil
      {:error, :eexist} -> nil
    end
  end
end
