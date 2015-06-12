require "rails_helper"

describe PhotoUploader, type: :uploader do
  let(:uploader) { described_class.new(ExampleClass.new(1), :image) }

  it "raises an error and prevents the upload when non-images are uploaded" do
    expect { File.open(Rails.root.join("fixtures", "carrierwave", "text.txt")) { |f| uploader.store!(f) } }.
      to raise_error CarrierWave::IntegrityError, 'You are not allowed to upload "txt" files, allowed types: jpg, jpeg, gif, png'
  end

  it "stores to the correct location" do
    expect(uploader.store_dir).to eq "uploads/example_classes/1/image"
  end

  context "with file" do
    before do
      described_class.enable_processing = true
      File.open(Rails.root.join("fixtures", "carrierwave", "image.png")) { |f| uploader.store!(f) }
    end

    after do
      described_class.enable_processing = false
      uploader.remove!
    end

    it "should make the image readable only to the owner and not executable" do
      expect(uploader).to have_permissions(0644)
    end

    it "generates a random filename" do
      expect(uploader.filename).to match /\w{8}(-\w{4}){3}-\w{12}\.png/
    end
  end
end
