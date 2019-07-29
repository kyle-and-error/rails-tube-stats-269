class PlaylistWatcher < ApplicationRecord
  belongs_to  :watcher, foreign_key: 'watcher_id', class_name: 'YoutubeAccount'
  belongs_to :playlist

  def initialize(list, account)
    self.playlist = list
    self.watcher = account
  end
end
