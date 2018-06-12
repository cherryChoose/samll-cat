class CombineItemsInCart < ActiveRecord::Migration[5.0]
  # 购物车中同一商品多次存储的合并为一条(line_items)
  def up
    Cart.all.each do |cart|
      # 计算每个购物车中商品总数
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id,quantity|
        if quantity > 1
          #  删除同一个商品,增加数量 delete_all(不掉用回调信息直接拼接sql处理)
          cart.line_items.where(product_id: product_id).delete_all

          # 替换成一个商品,共添加了几个
          item = cart.line_items.create(product_id: product_id)
          item.quantity = quantity
          # save! 保存错误抛出异常
          item.save!
        end
      end
    end
  end

  # rollback 恢复数据
  def down
    LineItem.where("quantity > 1").each do |line_item|
      # 添加相同产品,quantity = 1
      line_item.create(
          cart_id: line_item.cart_id,
          product_id: line_item.product_id,
          quantity: 1
      )

      # 删除原有记录
      line_item.destory
    end
  end
end
