defmodule Octicons do
  @moduledoc """
  Octicons are a scalable set of icons handcrafted with <3 by GitHub.

  See [the website][octicons] for an up-to-date reference of all of the available icons.

  > **Note:** This module is designed to operate identically to the [Node module][octicons-node] of
  the same name.

  [octicons]: https://octicons.github.com/
  [octicons-node]: https://www.npmjs.com/package/octicons
  """

  alias Octicons.Storage

  @type octicon_name :: String.t | atom
  @type t :: map

  @doc """
  Retrieves the attributes of the icon or `nil` if the named icon doesn't exist.

  ## Examples

      iex> Octicons.icon(:beaker)
      %{"aria-hidden" => "true", "class" => "octicons octicons-beaker",
        "height" => "16",
        "keywords" => ["experiment", "labs", "experimental", "feature", "test",
         "science", "education", "study", "development", "testing"],
        "path" => "<path fill-rule=\"evenodd\" d=\"M14.38 14.59L11 7V3h1V2H3v1h1v4L.63 14.59A1 1 0 0 0 1.54 16h11.94c.72 0 1.2-.75.91-1.41h-.01zM3.75 10L5 7V3h5v4l1.25 3h-7.5zM8 8h1v1H8V8zM7 7H6V6h1v1zm0-3h1v1H7V4zm0-3H6V0h1v1z\"/>",
        "symbol" => "beaker", "version" => "1.1", "viewBox" => "0 0 16 16",
        "width" => "16"}
  """
  @spec icon(octicon_name) :: t | nil
  def icon(name) when is_atom(name), do: icon(Atom.to_string(name))

  def icon(name) do
    name
    |> Storage.get_data
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

      iex> Octicons.toSVG(:beaker)
      "<svg aria-hidden=\"true\" class=\"octicons octicons-beaker\" height=\"16\" version=\"1.1\" viewBox=\"0 0 16 16\" width=\"16\"><path fill-rule=\"evenodd\" d=\"M14.38 14.59L11 7V3h1V2H3v1h1v4L.63 14.59A1 1 0 0 0 1.54 16h11.94c.72 0 1.2-.75.91-1.41h-.01zM3.75 10L5 7V3h5v4l1.25 3h-7.5zM8 8h1v1H8V8zM7 7H6V6h1v1zm0-3h1v1H7V4zm0-3H6V0h1v1z\"/></svg>"
  """
  @spec toSVG(octicon_name | t, keyword) :: String.t
  def toSVG(icon, options \\ [])

  def toSVG(nil, _), do: nil

  def toSVG(name, options) when is_atom(name) or is_binary(name), do: toSVG(icon(name), options)

  def toSVG(icon_data, options) when is_list(options), do: toSVG(icon_data, to_string_key_map(options))

  def toSVG(icon_data = %{}, options) do
    symbol = icon_data["symbol"]
    path = icon_data["path"]

    "<svg #{html_attributes(symbol, options)}>#{path}</svg>"
  end

  @doc """
  Get the version of the packaged Octicons data.

  ## Example

      iex> Octicons.version()
      "5.0.1"
  """
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
    map
    |> Map.merge(
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
    map
    |> Map.merge(%{"height" => height, "width" => width})
  end

  defp dimensions(map, key, %{"height" => height}) do
    data = Storage.get_data(key)

    map
    |> Map.merge(
      %{
        "height" => height,
        "width" => round(parse_int(height) * parse_int(data["width"]) / parse_int(data["height"]))
      }
    )
  end

  defp dimensions(map, key, %{"width" => width}) do
    data = Storage.get_data(key)

    map
    |> Map.merge(
      %{
        "height" => round(parse_int(width) * parse_int(data["height"]) / parse_int(data["width"])),
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
    |> Storage.get_data
    |> Map.merge(default_options(key))
    |> Map.merge(options)
    |> dimensions(key, options)
    |> class(key, options)
    |> aria(options)
    |> Map.delete("keywords")
    |> Map.delete("path")
    |> Map.to_list
    |> Enum.map(fn({key, value}) -> "#{key}=\"#{value}\"" end)
    |> Enum.join(" ")
    |> String.trim
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
    list
    |> Enum.reduce(%{}, fn({key, value}, map) ->
         map
         |> Map.put(Atom.to_string(key), value)
       end)
  end
end
