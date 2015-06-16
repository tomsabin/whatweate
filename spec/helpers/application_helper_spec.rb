require "rails_helper"

describe ApplicationHelper do
  include described_class

  describe "javascript_require" do
    context "for a single module" do
      it { expect(javascript_require("test")).to include("require('test');") }
    end

    context "for multiple modules" do
      it "should include \"require('foo'); require('bar'); require('baz');\"" do
        script_tag = javascript_require("foo", "bar", "baz")
        expect(script_tag).to include("require('foo');")
        expect(script_tag).to include("require('bar');")
        expect(script_tag).to include("require('baz');")
      end
    end
  end
end
