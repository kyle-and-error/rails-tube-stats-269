class PlaylistWatcher < ApplicationRecord
  belongs_to :youtube_account
  belongs_to :playlist
end
