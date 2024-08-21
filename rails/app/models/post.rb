class Post < ApplicationRecord
  # mount_uploader :image_url, ImageUploader
  belongs_to :user

  validates :title, presence: true
  validates :uid, presence: true, uniqueness: true
end
