
class Product < ApplicationRecord
  # 验证
  validates :title,:description,presence: true
  validates :title,uniqueness: true
  validates :price,numericality:{ greater_than_or_equal_to: 0.01 }

  # 关联关系
  has_many :attachments,as: :attachmentable
  has_many :line_items

  # 回调
  after_save :clear_cache
  before_destroy :ensure_not_referenced_by_any_item

  def clear_cache
    $namespaced_redis.del "products"
  end

  private

  # 确保没有商品在引用此产品
  def ensure_not_referenced_by_any_item
    if line_items.present?
      errors.add(:base,'line item present')
      throw :abort
    end
  end

end
