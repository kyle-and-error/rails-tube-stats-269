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

  before_save :initialize_data

  def url
    + youtube_id
  end

  private

  def initialize_data
    Yt.configuration.client_id = '546111180417-nu0vq86o5tilefhoiuvgo9fluvlgaof7.apps.googleusercontent.com'
    Yt.configuration.client_secret = 'S8K_ZRtM711nSqsoMmCwo_3p'
    account = Yt::Account.new refresh_token: refresh_token
    init_account(account)
    init_creator(account)
  end

  def init_account(account)
    youtube_id = account.channel.id
    email = account.email
    username = account.name
    username = email if username.nil?
    avatar = account.avatar_url
    location = account.locale
    name = username if name.nil?
  end

  def init_creator(account)
    channel = account.channel
    creator = Creator.new
    creator.youtube_id
  end

  def init_playlists(account)
    account.playlists.each do |yt_playlist|
      list = Playlist.new title: yt_playlist.title
      list.youtube_id = yt_playlist.id
      list.creator_id
      list.
    end

  end
end
