class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include CurrentCart
  protect_from_forgery with: :exception
  before_action :set_cart

  # rescue_form 拦截了由find方法引起的异常
  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound,
              with: :render_404

  rescue_from NoMethodError,with: :render_500

  # devise 可接受参数白名单
  # devise_parameter_sanitizer.permit(:sign_in) 登陆白名单
  # devise_parameter_sanitizer.permit(:sign_up) 注册参数白名单
  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)

    if devise_controller?
      devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(*User::ACCESSABLE_ATTRS) }
      devise_parameter_sanitizer.permit(:account_update) do |u|
        if current_user.email_locked?
          u.permit(*User::ACCESSABLE_ATTRS)
        else
          u.permit(:email, *User::ACCESSABLE_ATTRS)
        end
      end
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(*User::ACCESSABLE_ATTRS) }
    end
    # cookie 签名
    cookies.signed[:user_id] ||= current_user.try(:id)
  end

  # 重写devise 登陆成功和登出方法
  def after_sign_in_path_for(resource)
    orders_path
  end

  def after_sign_out_path_for(scope)
    store_index_path
  end

  def render_404(e)
    # e ActiveRecord::RecordNotFound 或者ActionController::RoutingError 的一个实例
    logger.error { "Rescue From #{e.class}:  #{e.message}" }
    render file: "public/404", status: 404
  end

  def render_500(e)
    logger.error{" Rescue From #{e.class}: #{e.message}"}
    render file: "public/500", status: 500
  end
end
