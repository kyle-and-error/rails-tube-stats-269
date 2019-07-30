class PlaylistWatcher < ApplicationRecord
  belongs_to :watcher, foreign_key: 'watcher_id', class_name: 'YoutubeAccount'
  belongs_to :playlist
end
