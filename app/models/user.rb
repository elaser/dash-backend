class User < ActiveRecord::Base
  has_many :created_apps, :foreign_key => 'creator_id', :class_name => "App"
  has_and_belongs_to_many :apps
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_authentication_token

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  private
  # User needs to have an authentication_token otherwise w won't be able to authentication this user!  This will be
  # fired on the before_save callback
  def ensure_authentication_token
  	self.authentication_token = generate_authentication_token if authentication_token.blank?
  end
end
