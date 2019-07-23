class PlaylistVideo < ApplicationRecord
  belongs_to :videos
  belongs_to :playlists
end
