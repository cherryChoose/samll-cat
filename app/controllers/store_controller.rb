class StoreController < ApplicationController

  # 为了方便使用helper中方法
  #include StoreHelper
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order(:title)
  end
end
