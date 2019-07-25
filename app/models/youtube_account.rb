class YoutubeAccount < ApplicationRecord
  REDIRECT_URI = ENV["NGROK_URI"]+'/dashboard'
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

  before_save :initialize_data

  private

  def initialize_data
    account = Yt::Account.new authorization_code: code, redirect_uri: REDIRECT_URI
    id = account.channel.id
    email = account.email
    username = account.name
    avatar = account.avatar_url
    location = account.locale
    name = username if name.nil?
  end
end
