class Gram < ApplicationRecord
  belongs_to :user
  has_many :comments
  validates :message, presence:true, length: { maximum: 100, minimum: 5 }
  validates :image, presence:true

  mount_uploader :image, ImageUploader

  def next_gram
    @gram = Gram.where('id > ?', id).first
  end

  def previous_gram
    @gram = Gram.where('id < ?', id).last
  end
end
