class Post < ApplicationRecord
  mount_uploader :image_url, ImageUploader

  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  belongs_to :user

  validates :title, presence: true
  validates :uid, presence: true, uniqueness: true
end
