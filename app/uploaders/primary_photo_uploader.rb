class PrimaryPhotoUploader < PhotoUploader
  process resize_to_fill: [1024, 678]

  version :thumb do
    process resize_to_fill: [292, 194]
  end

  def default_url
    ActionController::Base.helpers.asset_path("events/" + ["primary_default", version_name].compact.join('_') + ".png")
  end

  def default_url?
    default_url == url
  end
end
