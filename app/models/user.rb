class User < ApplicationRecord

  include User::Omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable,
         :authentication_keys => [:login]
  attr_accessor :login
  # devise 参数白名单
  ACCESSABLE_ATTRS = %i[name website github qq password password password_confirmation  phone email twitter]
  # 验证
  validates :name, presence: true, length: {in: 2..10}
  validates :phone,presence: true
  validates :password, presence: true, on: :create



  # 删除账号时，重置手机号
  # 由于email在数据库是唯一，user软删除后，不重置email会导致该手机号无法再次注册
  before_destroy do
    self.update_column(:email, "#{self.email}_#{Time.current.to_s(:number)}")
  end

  # 重写 login getter 和 setter
  def login=(login)
    @login = login
  end

  def login
    @login || self.phone || self.email
  end

  # 用户可以使用email和phone 登陆(不去分大小写)
  # d重写devise中find_first_by_auth_conditions
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(phone) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:phone].nil?
        where(conditions).first
      else
        where(phone: conditions[:phone]).first
      end
    end
  end


end
