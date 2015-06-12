class PhotosUploader < PhotoUploader
  process :resize_to_fit => [1024, 678]

  version :thumb do
    process :resize_to_fill => [292, 194]
  end
end
