module CurrentCart

  # 使用private 表示set_cart 为了避免rails把它当中制作控制器动作
  private

  def set_cart
    begin
      @cart = Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end

end