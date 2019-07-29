class WatchedVideo < ApplicationRecord
  belongs_to :watch
  belongs_to :video
  has_many :comments

  validates :like_status, :datetime_watched, presence: true
  enum like_status: %i[not_liked liked disliked]
end
