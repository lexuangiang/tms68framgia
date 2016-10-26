# encoding: utf-8

class ImgSubjectUploader < CarrierWave::Uploader::Base
  storage :file
  def default_url *args
    "/assets/" + [version_name, "subject.png"].compact.join('_')
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
