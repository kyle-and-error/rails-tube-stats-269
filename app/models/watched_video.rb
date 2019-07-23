class WatchedVideo < ApplicationRecord
  belongs_to :watch
  belongs_to :video

  validates :like_status, :date_watched, presence: true
  enum like_status: %i[not_liked liked disliked]
end
