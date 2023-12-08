class Tweet < ApplicationRecord
  belongs_to :user
  #Self Join
  belongs_to :replied_to, class_name: "Tweet", optional: true
  has_many :replies, class_name: "Tweet", foreign_key: "replied_to_id", dependent: :destroy
   #Associations
   has_many :likes
   has_many :liked_by_users, through: :likes, source: :user
    # Validations
  validates :body, presence: true, length: { maximum: 140 }
  validate :valid_replied_to_id, unless: -> { replied_to_id.nil? }

  private

  def valid_replied_to_id
    unless Tweet.exists?(replied_to_id)
      errors.add(:replied_to_id, "must be a valid Tweet id")
    end
  end
end