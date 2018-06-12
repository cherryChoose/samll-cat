require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Store
  class Application < Rails::Application

    config.time_zone = 'Beijing'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'models', '*.{rb,yml}').to_s]
    config.i18n.default_locale = "zh-CN"
    # 将缓存放入redis中压缩超过32K的数据压缩以后再放入缓存,默认所有的key失效时间为8小时
    #config.cache_store = :redis_store,$namespaced_redis
  end
end
