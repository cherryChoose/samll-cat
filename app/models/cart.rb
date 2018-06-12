class Cart < ApplicationRecord

  has_many :line_items,dependent: :destroy

  # 如果添加的商品存在数量+1,否则添加新产品
  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product.id)
      current_item.price = product.price
    end
    current_item
  end
  # 购物车总价前
  def total_price
    line_items.to_a.sum{|item| item.total_price}
  end
end
