class OrdersController < ApplicationController
  before_action :set_cart,only:[:new,:create]
  before_action :set_order,only: [:show, :edit, :update, :destroy]
  before_action :ensure_cart_isnot_empty

  def index

  end

  def new

  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  def ensure_cart_isnot_empty
    if @cart.line_items.empty?
      redirect_to store_index_url,notice: 'Your Cart is empty'
    end
  end
end
