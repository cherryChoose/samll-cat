require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product attributes must not empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new(title: 'Iphonex',description: "刘海手机" )
    product.price = -1
    assert product.invalid?
    assert_equal [I18n.t('errors.models.product.attributes.price.greater_than_or_equal_to')],product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal = [I18n.t('errors.models.product.attributes.price.greater_than_or_equal_to')],product.errors[:price]

    product.price = 1
    assert product.valid?

  end
  test "product is not valid without a unique title" do
    product = Product.new(title: products(:iphone_for).title,
                          description:  "test unique title",
                          price: 2999
    )
    assert product.invalid?
    assert_equal [I18n.t('errors.messages.taken')],product.errors[:title]

  end

end
