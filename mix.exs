defmodule Octicons.Mixfile do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :octicons,
      version: @version,
      deps: deps(),

      name: "Octicons",
      description: "Provides the SVG versions of GitHub's Octicons to an Elixir application",
      source_url: "https://github.com/lee-dohm/octicons-ex",
      homepage_url: "https://github.com/lee-dohm/octicons-ex",
      docs: docs(),
      package: package(),

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
      {:poison, "~> 2.0"},
      {:cmark, "~> 0.7.0", only: :dev},
      {:ex_doc, "~> 0.16.1", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "LICENSE.md"]
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Lee Dohm"],
      links: %{"GitHub" => "https://github.com/lee-dohm/octicons-ex"}
    ]
  end
end
