require "rails_helper"
require "carrierwave/test/matchers"

describe EventPrimaryPhotoUploader do
  include CarrierWave::Test::Matchers

  let(:event) { FactoryGirl.create(:event) }
  let(:uploader) { described_class.new(event, :primary_photo) }

  context "default images" do
    it "returns the correct url for the full image" do
      expect(uploader.url).to eq "/assets/events/primary_default.png"
    end

    it "returns the correct url for the thumb image" do
      expect(uploader.thumb.url).to eq "/assets/events/primary_default_thumb.png"
    end

    describe "default_url?" do
      it { expect(uploader.default_url?).to eq true }
    end
  end

  context "uploading images" do
    let(:path_to_image) { Rails.root.join("fixtures", "carrierwave", "image.png") }

    before do
      described_class.enable_processing = true
      File.open(path_to_image) { |f| uploader.store!(f) }
    end

    after do
      described_class.enable_processing = false
      uploader.remove!
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

    it "should make the image readable only to the owner and not executable" do
      expect(uploader).to have_permissions(0644)
    end

    describe "default_url?" do
      it { expect(uploader.default_url?).to eq false }
    end
  end

  context "uploading non-images" do
    let(:path_to_image) { Rails.root.join("fixtures", "carrierwave", "text.txt") }

    it "raises an error and prevents the upload" do
      expect { File.open(path_to_image) { |f| uploader.store!(f) } }.
        to raise_error CarrierWave::IntegrityError, 'You are not allowed to upload "txt" files, allowed types: jpg, jpeg, gif, png'
    end
  end
end
