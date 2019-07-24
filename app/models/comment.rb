class Comment < ApplicationRecord
  belongs_to :watched_video

  validates :text, presence: true
end
