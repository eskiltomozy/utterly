class Comment < ApplicationRecord
  belongs_to :gram
  belongs_to :user
  validates :message, presence:true, length: { maximum: 100, minimum: 5 }
end
