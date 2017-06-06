defmodule Octicons.Test do
  use ExUnit.Case

  test "icon information on an icon that exists" do
    icon = Octicons.icon("beaker")

    assert icon
    assert icon["symbol"] == "beaker"
    assert icon["aria-hidden"]
    assert icon["class"] == "octicons octicons-beaker"
    assert icon["height"] == "16"
    assert icon["width"] == "16"
  end

  test "accepts the icon name as a symbol" do
    icon = Octicons.icon(:beaker)

    assert icon
    assert icon["symbol"] == "beaker"
    assert icon == Octicons.icon("beaker")
  end

  test "non-existent icon returns nil" do
    refute Octicons.icon("supercalifragilisticexpialidocious")
  end

  test "toSVG on icon that exists" do
    svg = Octicons.toSVG("beaker")

    assert svg == "<svg aria-hidden=\"true\" class=\"octicons octicons-beaker\" height=\"16\" version=\"1.1\" viewBox=\"0 0 16 16\" width=\"16\"><path fill-rule=\"evenodd\" d=\"M14.38 14.59L11 7V3h1V2H3v1h1v4L.63 14.59A1 1 0 0 0 1.54 16h11.94c.72 0 1.2-.75.91-1.41h-.01zM3.75 10L5 7V3h5v4l1.25 3h-7.5zM8 8h1v1H8V8zM7 7H6V6h1v1zm0-3h1v1H7V4zm0-3H6V0h1v1z\"/></svg>"
  end

  test "toSVG on icon that doesn't exist returns nil" do
    refute Octicons.toSVG("supercalifragilisticexpialidocious")
  end
end
