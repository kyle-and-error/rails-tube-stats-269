class YoutubeAccount < ApplicationRecord
  belongs_to :user

  has_many :playlist_watchers, dependent: :destroy
  has_many :playlists, through: :playlist_watchers
  has_many :playlist_videos, through: :playlists

  has_many :watches, dependent: :destroy
  has_many :creators, through: :watches
  has_many :watched_videos, through: :watches
  has_many :videos, through: :watched_videos
  has_many :comments, through: :watched_videos

  has_many :suggestions, dependent: :destroy

  has_many :video_watched, through: :watchex

  validates :email, uniqueness: true

  def subscribe_url
    url + '?sub_confirmation=1'
  end
end
