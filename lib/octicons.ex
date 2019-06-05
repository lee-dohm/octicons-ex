defmodule Octicons do
  @moduledoc """
  Octicons are a scalable set of icons handcrafted with <3 by GitHub.

  See [the website][octicons] for an up-to-date reference of all of the available icons.

  [octicons]: https://octicons.github.com/
  """

  alias Octicons.Storage

  @type octicon_name :: String.t() | atom
  @type t :: map

  @doc """
  Retrieves the attributes of the icon or `nil` if the named icon doesn't exist.

  ## Examples

  ```
  iex> Octicons.icon(:beaker)
  %{
    "aria-hidden" => "true",
    "class" => "octicons octicons-beaker",
    "figma" => %{"file" => "FP7lqd1V00LUaT5zvdklkkZr", "id" => "0:26"},
    "height" => 16,
    "keywords" => ["experiment", "labs", "experimental", "feature", "test",
     "science", "education", "study", "development", "testing"],
    "name" => "beaker",
    "path" => "<path fill-rule=\\"evenodd\\" d=\\"M14.38 14.59L11 7V3h1V2H3v1h1v4L.63 14.59A1 1 0 0 0 1.54 16h11.94c.72 0 1.2-.75.91-1.41h-.01zM3.75 10L5 7V3h5v4l1.25 3h-7.5zM8 8h1v1H8V8zM7 7H6V6h1v1zm0-3h1v1H7V4zm0-3H6V0h1v1z\\"/>",
    "symbol" => "beaker",
    "version" => "1.1",
    "viewBox" => "0 0 16 16",
    "width" => 16
  }
  ```
  """
  @spec icon(octicon_name) :: t | nil
  def icon(name) when is_atom(name), do: icon(Atom.to_string(name))

  def icon(name) do
    name
    |> Storage.get_data()
    |> merge_additional_info(name)
  end

  @doc """
  Returns the SVG tag that renders the icon.

  ## Options

  * `:"aria-label"` Aria label for the SVG tag. When `aria-label` is specified, the `aria-hidden`
    attribute is removed.
  * `:class` CSS class text to add to the classes already present
  * `:height` Height in pixels to render the icon. If only `:height` is specified, width is
    calculated to maintain the aspect ratio.
  * `:width` Width in pixels to render the icon. If only `:width` is specified, height is
    calculated to maintain the aspect ratio.

  ## Examples

  ```
  iex> Octicons.to_svg(:beaker)
  "<svg aria-hidden=\\"true\\" class=\\"octicons octicons-beaker\\" height=\\"16\\" version=\\"1.1\\" viewBox=\\"0 0 16 16\\" width=\\"16\\"><path fill-rule=\\"evenodd\\" d=\\"M14.38 14.59L11 7V3h1V2H3v1h1v4L.63 14.59A1 1 0 0 0 1.54 16h11.94c.72 0 1.2-.75.91-1.41h-.01zM3.75 10L5 7V3h5v4l1.25 3h-7.5zM8 8h1v1H8V8zM7 7H6V6h1v1zm0-3h1v1H7V4zm0-3H6V0h1v1z\\"/></svg>"
  ```
  """
  @doc since: "v0.7.0"
  @spec to_svg(octicon_name | t, keyword) :: String.t()
  def to_svg(icon, options \\ [])

  def to_svg(nil, _), do: nil

  def to_svg(name, options) when is_atom(name) or is_binary(name), do: to_svg(icon(name), options)

  def to_svg(icon_data, options) when is_list(options),
    do: to_svg(icon_data, to_string_key_map(options))

  def to_svg(icon_data = %{}, options) do
    symbol = icon_data["symbol"]
    path = icon_data["path"]

    "<svg #{html_attributes(symbol, options)}>#{path}</svg>"
  end

  @doc false
  @deprecated "Use Octicons.to_svg/2 in its place."
  def toSVG(icon, options \\ []), do: to_svg(icon, options)

  @doc """
  Get the version of the packaged Octicons data.

  ## Examples

  ```
  iex> Octicons.version()
  "8.5.0"
  ```
  """
  @spec version() :: String.t()
  def version do
    Storage.get_version()
  end

  defp aria(map, %{"aria-label" => label}) do
    map
    |> Map.merge(%{"aria-label" => label})
    |> Map.merge(%{"role" => "img"})
    |> Map.delete("aria-hidden")
  end

  defp aria(map, _), do: map

  defp class(map, key, %{"class" => option_class}) do
    Map.merge(
      map,
      %{
        "class" => String.trim("octicons octicons-#{key} #{option_class}")
      }
    )
  end

  defp class(map, _, _), do: map

  defp dimensions(map, key, options = %{"height" => height}) when not is_binary(height) do
    dimensions(map, key, Map.put(options, "height", Integer.to_string(height)))
  end

  defp dimensions(map, key, options = %{"width" => width}) when not is_binary(width) do
    dimensions(map, key, Map.put(options, "width", Integer.to_string(width)))
  end

  defp dimensions(map, _, %{"height" => height, "width" => width}) do
    Map.merge(map, %{"height" => height, "width" => width})
  end

  defp dimensions(map, key, %{"height" => height}) do
    data = Storage.get_data(key)

    Map.merge(
      map,
      %{
        "height" => height,
        "width" => round(parse_int(height) * data["width"] / data["height"])
      }
    )
  end

  defp dimensions(map, key, %{"width" => width}) do
    data = Storage.get_data(key)

    Map.merge(
      map,
      %{
        "height" => round(parse_int(width) * data["height"] / data["width"]),
        "width" => width
      }
    )
  end

  defp dimensions(map, _, _), do: map

  defp default_options(key) do
    data = Storage.get_data(key)

    %{
      "version" => "1.1",
      "width" => data["width"],
      "height" => data["height"],
      "viewBox" => "0 0 #{data["width"]} #{data["height"]}",
      "class" => "octicons octicons-#{key}",
      "aria-hidden" => "true"
    }
  end

  defp html_attributes(key, options) do
    key
    |> Storage.get_data()
    |> Map.merge(default_options(key))
    |> Map.merge(options)
    |> dimensions(key, options)
    |> class(key, options)
    |> aria(options)
    |> Map.drop(["figma", "keywords", "name", "path"])
    |> Map.to_list()
    |> Enum.map(fn {key, value} -> "#{key}=\"#{value}\"" end)
    |> Enum.join(" ")
    |> String.trim()
  end

  defp merge_additional_info(nil, _), do: nil

  defp merge_additional_info(map, name) do
    map
    |> Map.merge(default_options(name))
    |> Map.merge(%{"symbol" => name})
  end

  defp parse_int(text) do
    {int, _} = Integer.parse(text)

    int
  end

  defp to_string_key_map(list) do
    Enum.reduce(list, %{}, fn {key, value}, map -> Map.put(map, Atom.to_string(key), value) end)
  end
end
