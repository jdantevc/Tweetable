class User < ApplicationRecord
  validates :role, presence: { message: "must be selected" }
  before_create :default_avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
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
end