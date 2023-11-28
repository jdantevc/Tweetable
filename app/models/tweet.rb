class Tweet < ApplicationRecord
  belongs_to :user
  #Self Join
  belongs_to :replied_to, class_name: "Tweet", optional: true
  has_many :replies, class_name: "Tweet", foreign_key: "replied_to_id", dependent: :destroy, inverse_of: "replied_to"
   #Associations
   has_many :likes
   has_many :liked_by_users, through: :likes, source: :user
end