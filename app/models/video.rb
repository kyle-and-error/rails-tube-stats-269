class Video < ApplicationRecord
  belongs_to :creator, class_name: "YoutubeAccount"
  has_many :watched_videos
  has_many :playlist_videos
  has_mamy :playlists, through: :playlist_videos
  has_many :comments
  has_many :suggestions

  validates :title, :url, presence: true
end
