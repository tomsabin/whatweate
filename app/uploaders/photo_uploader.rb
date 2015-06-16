class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore.pluralize}/#{model.id}/#{mounted_as}"
  end

  def filename
    "#{Digest::MD5::hexdigest(original_filename)}.#{file.extension}" if original_filename.present?
  end
end
