class Attachment < ApplicationRecord
  # 拓展
  include ActionView::Helpers::NumberHelper
  # 第一个参数 数据库中字段file,使用AvatarUploader处理
  mount_uploaders :file, AvatarUploader

  # 验证
  validates :attachmentable, presence: true
  validates :file, presence: true

  # 关联关系
  belongs_to :attachmentable,polymorphic: true

  # 回调
  before_save :set_attachment_attributes

  protected

  def set_attachment_attributes
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.file_size = file.file.size
      self.human_size = number_to_human_size(self.file_size)
      self.file_name = file.file.original_filename
    end
  end
end