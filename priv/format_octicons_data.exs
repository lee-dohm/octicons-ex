data_path = Path.expand("../node_modules/@primer/octicons/build/data.json", __DIR__)
metadata_path = Path.expand("../node_modules/@primer/octicons/package.json", __DIR__)

data =
  data_path
  |> File.read!()
  |> Jason.decode!()

metadata =
  metadata_path
  |> File.read!()
  |> Jason.decode!()

File.write!(Path.join(__DIR__, "data.exs"), inspect(data, limit: :infinity, pretty: true, width: 80))
File.write!(Path.join(__DIR__, "metadata.exs"), inspect(metadata, limit: :infinity, pretty: true, width: 80))
