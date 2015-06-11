class EventPrimaryPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :resize_to_fit => [1024, 678]

  version :thumb do
    process :resize_to_fit => [292, 194]
  end

  def default_url
    ActionController::Base.helpers.asset_path("events/" + ["primary_default", version_name].compact.join('_') + ".png")
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
