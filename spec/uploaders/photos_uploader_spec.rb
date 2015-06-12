require "rails_helper"

describe PhotosUploader, type: :uploader do
  let(:path_to_image) { Rails.root.join("fixtures", "carrierwave", "image.png") }
  let(:event) { FactoryGirl.create(:event) }

  before do
    described_class.enable_processing = true
    event.photos = [File.open(path_to_image), File.open(path_to_image)]
    event.save
  end

  after do
    described_class.enable_processing = false
    event.remove_photos!
  end

  describe "multiple files" do
    it { expect(event.photos.size).to eq 2 }
  end

  context "the full version" do
    it "should scale down a landscape image to be exactly 1024 by 678 pixels" do
      expect(event.photos.first).to have_dimensions(1024, 678)
    end

    it "has the correct url" do
      expect(event.photos.first.url).to match /uploads\/events\/(\d)+\/photos\/(\h){32}.png/
    end
  end

  context "the thumb version" do
    it "should scale down a landscape image to fit within 292 by 194 pixels" do
      expect(event.photos.first.thumb).to be_no_larger_than(292, 194)
    end

    it "has the correct url" do
      expect(event.photos.first.thumb.url).to match /uploads\/events\/(\d)+\/photos\/thumb_(\h){32}.png/
    end
  end
end
