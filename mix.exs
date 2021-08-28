defmodule Octicons.Mixfile do
  use Mix.Project

  @source_url "https://github.com/lee-dohm/octicons-ex"
  @version "0.8.0"

  def project do
    [
      app: :octicons,
      name: "Octicons",
      version: @version,
      deps: deps(),
      docs: docs(),
      package: package(),
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod
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
      {:cmark, "~> 0.7", only: :dev},
      {:ex_doc, "~> 0.21.3", only: :dev, runtime: false},
      {:jason, "~> 1.1", only: :dev},
      {:version_tasks, "~> 0.11.3", only: :dev}
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      homepage_url: @source_url,
      formatters: ["html"]
    ]
  end

  defp package do
    [
      description: "Provides the SVG versions of GitHub's Octicons to an Elixir application",
      licenses: ["MIT"],
      maintainers: ["Lee Dohm"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
