class Watch < ApplicationRecord
  belongs_to :watcher, foreign_key: 'watcher_id', class_name: 'YoutubeAccount'
  belongs_to :creator
  has_many :watched_videos
  has_many :videos, through: :watched_videos

  validates :subscription, presence: true
end
