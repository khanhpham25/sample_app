class Micropost < ApplicationRecord
  scope :recent_posts, -> {order created_at: :desc}
  scope :followed_posts, -> user_ids{where "user_id IN (?)", user_ids}
  mount_uploader :picture, PictureUploader

  belongs_to :user

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate  :picture_size

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, "should be less than 5MB"
    end
  end
end
