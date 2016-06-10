class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:twitter]

  has_many :tweets, dependent: :destroy

  def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email.present? ? auth.info.email : "#{auth.uid}-#{auth.provider}@twitter.com"
        user.password = Devise.friendly_token[0,20]
      	user.access_token_secret = auth.credentials.secret
      	user.access_token = auth.credentials.token
      end
  end
end
