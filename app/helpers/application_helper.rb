module ApplicationHelper

  # 用于在form中，render model 的错误信息
  def error_messages(f)
    render "shared/error_messages", target: f.object
  end

  # 用于是否显示左侧购物车
  def hidden_div_if(condition, attributes = {},&block)
    if condition
      attributes["style"] = "display:none;"
    end
    # detail see http://doc.rubyfans.com/rails/v5.2/
    # => <div id=cart>render xxxxx</div>
    content_tag("div",attributes,&block)
  end

  # 显示闪现消息,显现消息出现再下次请求才会出现如果想本次请求出现flash[:now]
  #flash方法的消息会从保存到下一个action，和redirct_to方法一起使用
  #flash.now 方法的详细只会在当前视图显示，不会保存到下一个action，和render方法一起使用
  def flash_message
    debugger
    flash_messages = []
    flash.each do |type,message|
      type = :success if type.to_sym == :notice
      type = :danger  if type.to_sym == :alert
      text = content_tag(:div,link_to(raw('<i class = "fa fa-close"></i>'),"#",
                                      :class => 'close',"data-dismiss" => "alert") + message,
                                      class: "alert alert-#{type}")
      flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end



end
