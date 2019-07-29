class Playlist < ApplicationRecord
  belongs_to :creator

  has_many :playlist_watchers

  has_many :playlist_videos
  has_many :videos, through: :playlist_videos

  has_many :suggestions

  validates :title, presence: true
end
