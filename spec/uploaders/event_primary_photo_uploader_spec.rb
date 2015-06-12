require "rails_helper"
class ExampleClass < Struct.new(:id); end

describe EventPrimaryPhotoUploader, type: :uploader do
  let(:uploader) { described_class.new(klass, :primary_photo) }

  context "default images" do
    let(:klass) { FactoryGirl.create(:event) }

    describe "default_url?" do
      it { expect(uploader.default_url?).to eq true }
    end

    it "returns the correct url for the full image" do
      expect(uploader.url).to eq "/assets/events/primary_default.png"
    end

    it "returns the correct url for the thumb image" do
      expect(uploader.thumb.url).to eq "/assets/events/primary_default_thumb.png"
    end
  end

  context "uploading images" do
    let(:klass) { ExampleClass.new(1) }
    let(:path_to_image) { Rails.root.join("fixtures", "carrierwave", "image.png") }

    before do
      described_class.enable_processing = true
      File.open(path_to_image) { |f| uploader.store!(f) }
    end

    after do
      described_class.enable_processing = false
      uploader.remove!
    end

    it "stores to the correct location" do
      expect(uploader.store_dir).to eq "uploads/example_class/primary_photo/1"
    end

    describe "default_url?" do
      it { expect(uploader.default_url?).to eq false }
    end

    context "the full version" do
      it "should scale down a landscape image to be exactly 1024 by 679 pixels" do
        expect(uploader).to have_dimensions(1024, 678)
      end
    end

    context "the thumb version" do
      it "should scale down a landscape image to fit within 292 by 194 pixels" do
        expect(uploader.thumb).to be_no_larger_than(292, 194)
      end
    end
  end
end
