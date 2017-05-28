defmodule Octicons.Mixfile do
  use Mix.Project

  def project do
    [
      app: :octicons,
      version: "0.1.0",
      deps: deps(),

      name: "Octicons",
      source_url: "https://github.com/lee-dohm/octicons_ex",
      homepage_url: "https://github.com/lee-dohm/octicons_ex",
      docs: docs(),

      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Octicons.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.16.1", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "Octicons",
      extras: ["README.md"]
    ]
  end
end
