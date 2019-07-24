class Video < ApplicationRecord
  belongs_to :creator

  has_many :watched_videos
  has_many :comments, through: :watched_videos

  has_many :playlist_videos
  has_mamy :playlists, through: :playlist_videos

  has_many :suggestions

  validates :title, :url, presence: true
end
