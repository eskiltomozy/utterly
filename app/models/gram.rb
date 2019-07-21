class Gram < ApplicationRecord
  belongs_to :user
  has_many :comments
  validates :message, presence:true
  validates :image, presence:true

  mount_uploader :image, ImageUploader
end
