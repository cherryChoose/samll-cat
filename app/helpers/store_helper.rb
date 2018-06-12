module StoreHelper

=begin
  def fetch_products
    products =  $namespaced_redis.get("products")
    if products.blank?
      # TODO 某个商店的商品
      products = Product.all.to_json
      $namespaced_redis.set("products", products)
    end
    JSON.load products
  end
=end

end
