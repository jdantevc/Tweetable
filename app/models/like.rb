class Like < ApplicationRecord
  # Validations
  validates :user_id, uniqueness: { scope: :tweet_id, message: "has already liked this tweet" }
  # Associations
  belongs_to :user
  belongs_to :tweet
end