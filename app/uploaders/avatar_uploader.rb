class AvatarUploader < CarrierWave::Uploader::Base


  include CarrierWave::MiniMagick
  storage :file

  # 存储位置： uploads/product/file/1
  def store_dir
    "uploads/#{model.attachmentable.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 缩略图
  version :thumb, if: :image? do
    process resize_to_fit: [50,50]
  end

  # 预览图
  version :preview,if: :image? do
    process  resize_to_fit: [80,80]
  end

  # 允许上传文件拓展名
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # 默认图片
  def default_url(*args)
    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  protected

  def image?(new_file)
    new_file.content_type.include? 'image'
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
