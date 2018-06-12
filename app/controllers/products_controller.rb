class ProductsController < ApplicationController

  before_action :set_product, only: [:show, :edit, :update, :destroy]


  def index
    @products = Product.all
  end


  def show
  end


  def new
    @product = Product.new
  end


  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
       @product.attachments.create(file: params[:file]) if params[:file]
       redirect_to @product, notice: 'Product was successfully created.'
    else
       render :new
    end
  end

  def update
    @product.update(product_params)
    redirect_to @product, notice: 'Product was successfully updated.'
    @products = Product.all
    ActionCable.server.broadcast 'products',
                                 html: render_to_string('store/index',layout:false)

  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params[:product].permit!
    end
end
