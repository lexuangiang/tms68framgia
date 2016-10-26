# encoding: utf-8

class AvatarUrlUploader < CarrierWave::Uploader::Base

  storage :file
  def default_url *args
    "/assets/" + [version_name, "avatar.png"].compact.join('_')
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
