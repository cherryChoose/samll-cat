class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # model中使用routes url
  delegate :url_helpers, to: "Rails.application.routes"
end
