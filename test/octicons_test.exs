defmodule OcticonsTest do
  use ExUnit.Case

  describe "icon/1" do
    test "when the named icon exists", _context do
      icon = Octicons.icon("beaker")

      assert icon
      assert icon["symbol"] == "beaker"
      assert icon["aria-hidden"]
      assert icon["class"] == "octicons octicons-beaker"
      assert icon["height"] == 16
      assert icon["width"] == 16
    end

    test "when the icon is named with an atom", _context do
      icon = Octicons.icon(:beaker)

      assert icon
      assert icon["symbol"] == "beaker"
      assert icon["aria-hidden"]
      assert icon["class"] == "octicons octicons-beaker"
      assert icon["height"] == 16
      assert icon["width"] == 16
    end

    test "when given a non-existent icon name", _context do
      icon = Octicons.icon("supercalifragilisticexpialidocious")

      refute icon
    end
  end

  describe "toSVG/2" do
    test "when the named icon exists", _context do
      svg = Octicons.toSVG("beaker")

      assert svg ==
               ~s{<svg aria-hidden="true" class="octicons octicons-beaker" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M14.38 14.59L11 7V3h1V2H3v1h1v4L.63 14.59A1 1 0 0 0 1.54 16h11.94c.72 0 1.2-.75.91-1.41h-.01zM3.75 10L5 7V3h5v4l1.25 3h-7.5zM8 8h1v1H8V8zM7 7H6V6h1v1zm0-3h1v1H7V4zm0-3H6V0h1v1z"/></svg>}
    end

    test "when the aria label is given", _context do
      svg = Octicons.toSVG("beaker", "aria-label": "any-label")

      assert svg =~ ~s{aria-label="any-label"}
      assert svg =~ ~s{role="img"}
      refute svg =~ ~s{aria-hidden}
    end

    test "when both width and height are specified", _context do
      svg = Octicons.toSVG("beaker", height: 300, width: 400)

      assert svg =~ ~s{height="300"}
      assert svg =~ ~s{width="400"}
    end

    test "when only height is specified", _context do
      svg = Octicons.toSVG("beaker", height: 300)

      assert svg =~ ~s{height="300"}
      assert svg =~ ~s{width="300"}
    end

    test "when only width is specified", _context do
      svg = Octicons.toSVG("beaker", width: 400)

      assert svg =~ ~s{height="400"}
      assert svg =~ ~s{width="400"}
    end

    test "when additional class names are given", _context do
      svg = Octicons.toSVG("beaker", class: "foo bar baz")

      assert svg =~ ~s{class="octicons octicons-beaker foo bar baz"}
    end

    test "when given a non-existent icon name", _context do
      svg = Octicons.toSVG("supercalifragilisticexpialidocious")

      refute svg
    end
  end
end
