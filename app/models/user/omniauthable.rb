# frozen_string_literal: true

class User
  # Omniauth 认证函数
  module Omniauthable
    extend ActiveSupport::Concern

    def bind?(provider)
      authorizations.collect(&:provider).include?(provider)
    end

    def bind_service(response)
      provider = response["provider"]
      uid      = response["uid"].to_s

      authorizations.create(provider: provider, uid: uid)
    end

    module ClassMethods
      def new_from_provider_data(provider, uid, data)
        User.new do |user|
          user.email =
            if data["email"].present? && !User.where(email: data["email"]).exists?
              data["email"]
            else
              "#{provider}+#{uid}@example.com"
            end

          user.name  = data["name"]

          if provider == "github"
            user.github = data["nickname"]
          end

          if user.login.blank?
            user.login = "u#{Time.now.to_i}"
          end

          if User.where(login: user.login).exists?
            user.login = "#{user.github}-github" # TODO: possibly duplicated user login here. What should we do?
          end

          user.password = Devise.friendly_token[0, 20]
          user.location = data["location"]
          user.tagline  = data["description"]
        end
      end

      %w[github].each do |provider|
        define_method "find_or_create_for_#{provider}" do |response|
          uid  = response["uid"].to_s
          data = response["info"]

          user = Authorization.find_by(provider: provider, uid: uid).try(:user)
          return user if user

          user = User.new_from_provider_data(provider, uid, data)
          if user.save(validate: false)
            Authorization.find_or_create_by(provider: provider, uid: uid, user_id: user.id)
            return user
          end

          Rails.logger.warn("User.create_from_hash 失败，#{user.errors.inspect}")
          return nil
        end
      end
    end
  end
end
