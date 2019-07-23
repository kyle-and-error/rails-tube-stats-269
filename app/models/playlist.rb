class Playlist < ApplicationRecord
  has_many :playlist_video
  has_many :suggestion

  belongs_to :youtube_account

  validates :title, presence: true
  validates :url, presence: true
end
