require "rails_helper"
class ExampleClass < Struct.new(:id); end

describe PhotoUploader, type: :uploader do
  let(:uploader) { described_class.new(ExampleClass.new(1), :image) }

  it "should make the image readable only to the owner and not executable" do
    File.open(Rails.root.join("fixtures", "carrierwave", "image.png")) { |f| uploader.store!(f) }
    expect(uploader).to have_permissions(0644)
  end

  it "raises an error and prevents the upload when non-images are uploaded" do
    expect { File.open(Rails.root.join("fixtures", "carrierwave", "text.txt")) { |f| uploader.store!(f) } }.
      to raise_error CarrierWave::IntegrityError, 'You are not allowed to upload "txt" files, allowed types: jpg, jpeg, gif, png'
  end

  it "stores to the correct location" do
    expect(uploader.store_dir).to eq "uploads/example_class/1/image"
  end

  it "generates a random filename" do
    File.open(Rails.root.join("fixtures", "carrierwave", "image.png")) { |f| uploader.store!(f) }
    expect(uploader.filename).to match /\w{8}(-\w{4}){3}-\w{12}\.png/
  end
end
