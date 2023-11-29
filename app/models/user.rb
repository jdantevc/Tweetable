class User < ApplicationRecord
  validates :role, presence: { message: "must be selected" }
  before_create :default_avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  #Active Storage
  has_one_attached :avatar
  #Associations
  has_many :tweets, dependent: :destroy
  has_many :likes
  has_many :liked_tweets, through: :likes, source: :tweet
  #Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }
  enum :role, { member: 0, admin: 1 }

  private
  def default_avatar
    return if avatar.attached?

    avatar.attach(io: File.open("app/assets/images/avatar.png"), filename: "default_avatar.png")
  end
  
  def self.from_omniauth(auth_hash)
    where(provider: auth_hash.provider, uid: auth_hash.uid).first_or_create do |user|
      user.provider = auth_hash.provider
      user.uid = auth_hash.uid
      user.username = auth_hash.info.nickname
      user.email = auth_hash.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end