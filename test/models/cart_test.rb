require 'test_helper'

class CartTest < ActiveSupport::TestCase
  def new_cart_with_one_product(product_name)
    cart = cars(:one)
    cart.add_product(products(product_name).id)
    cart
  end

  test 'cart should create a new line item when adding a new product' do
    cart = new_cart_with_one_product(:xiaomi)
    assert_equal 1, cart.line_items.count
    # 添加一个已经存在的手机型号
    line_item = cart.add_product(products(:iphone_for).id)
    assert_equal 2, cart.line_items.count
    assert_equal 2,line_item.quantity
  end
  test "cart line item should save price" do
    cart = carts(:one)
    product = products(:iphone_for)
    line_item = cart.add_product product.id
    assert_equal line_item.price, product.price,"cart line item did not save price"
  end

end
