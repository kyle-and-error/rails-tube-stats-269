class YoutubeAccount < ApplicationRecord
  belongs_to :user
  has_many :playlists, :videos, :watches
  has_many :watchers, through: :watches
end
