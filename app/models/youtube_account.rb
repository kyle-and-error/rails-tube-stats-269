class YoutubeAccount < ApplicationRecord
  belongs_to :user
  has_many :playlists, :videos
  has_many :watchers, through: :watcher_watches, source: :watcher

  has_many :watcher_watches, foreign_key: :creator_id, class_name: 'Watch'

  has_many :creators, through: :creator_watches, soruce: :creator

  has_many :creator_watches, foreign_key: :watcher_id, class_name: 'Watch'
end
