defmodule Octicons.Spec do
  use ESpec

  describe "icon/1" do
    context "when the named icon exists" do
      before do: {:shared, icon: Octicons.icon("beaker") }

      it do: expect(shared.icon).to_not be_nil()
      it do: expect(shared.icon["symbol"]).to eq("beaker")
      it do: expect(shared.icon["aria-hidden"]).to eq("true")
      it do: expect(shared.icon["class"]).to eq("octicons octicons-beaker")
      it do: expect(shared.icon["height"]).to eq("16")
      it do: expect(shared.icon["width"]).to eq("16")
    end

    context "when the icon is named with an atom" do
      before do: {:shared, icon: Octicons.icon(:beaker) }

      it do: expect(shared.icon).to_not be_nil()
      it do: expect(shared.icon["symbol"]).to eq("beaker")
      it do: expect(shared.icon["aria-hidden"]).to eq("true")
      it do: expect(shared.icon["class"]).to eq("octicons octicons-beaker")
      it do: expect(shared.icon["height"]).to eq("16")
      it do: expect(shared.icon["width"]).to eq("16")
    end

    context "when given a non-existent icon name" do
      it do: expect(Octicons.icon("supercalifragilisticexpialidocious")).to be_nil()
    end
  end

  describe "toSVG/2" do
    context "when the named icon exists" do
      before do: {:shared, svg: Octicons.toSVG("beaker")}

      it do: expect(shared.svg).to eq("<svg aria-hidden=\"true\" class=\"octicons octicons-beaker\" height=\"16\" version=\"1.1\" viewBox=\"0 0 16 16\" width=\"16\"><path fill-rule=\"evenodd\" d=\"M14.38 14.59L11 7V3h1V2H3v1h1v4L.63 14.59A1 1 0 0 0 1.54 16h11.94c.72 0 1.2-.75.91-1.41h-.01zM3.75 10L5 7V3h5v4l1.25 3h-7.5zM8 8h1v1H8V8zM7 7H6V6h1v1zm0-3h1v1H7V4zm0-3H6V0h1v1z\"/></svg>")

      context "and the aria-label option is given" do
        before do: {:shared, svg: Octicons.toSVG("beaker", "aria-label": "any-label")}

        it do: expect(shared.svg).to match("aria-label=\"any-label\"")
        it do: expect(shared.svg).to match("role=\"img\"")
        it do: expect(shared.svg).to_not match("aria-hidden")
      end

      context "and both height and width are specified" do
        before do: {:shared, svg: Octicons.toSVG("beaker", height: 300, width: 400)}

        it "passes both height and width through unchanged" do
          expect(shared.svg).to match("height=\"300\"")
          expect(shared.svg).to match("width=\"400\"")
        end
      end

      context "and only height is specified" do
        before do: {:shared, svg: Octicons.toSVG("beaker", height: 300)}

        it "scales width to maintain the aspect ratio" do
          expect(shared.svg).to match("height=\"300\"")
          expect(shared.svg).to match("width=\"300\"")
        end
      end

      context "and only width is specified" do
        before do: {:shared, svg: Octicons.toSVG("beaker", width: 400)}

        it "scales height to maintain the aspect ratio" do
          expect(shared.svg).to match("height=\"400\"")
          expect(shared.svg).to match("width=\"400\"")
        end
      end

      context "and additional classes are specified as options" do
        it do: expect(Octicons.toSVG("beaker", class: "foo bar baz")).to match("class=\"octicons octicons-beaker foo bar baz\"")
      end
    end

    context "when given a non-existent icon name" do
      it do: expect(Octicons.toSVG("supercalifragilisticexpialidocious")).to be_nil()
    end
  end
end
