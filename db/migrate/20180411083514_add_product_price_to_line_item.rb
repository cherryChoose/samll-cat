class AddProductPriceToLineItem < ActiveRecord::Migration[5.0]
  def up
    add_column :line_items, :price, :decimal, precision: 8, scale: 2

    say_with_time "Updating product prices to line_items " do
      LineItem.all.each do |line_item|
        line_item.update_attribute :price, line_item.product.price
      end
    end
  end

  def down
    remove_column :line_items, :price
  end
end
