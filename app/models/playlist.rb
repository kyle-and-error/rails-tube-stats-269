class Playlist < ApplicationRecord
  belongs_to :creator

  has_many :playlist_watchers

  has_many :playlist_videos
  has_many :videos, through: :playlist_videos

  has_many :suggestions

  validates :title, presence: true

  def self.initialize_with_yt(yt_playlist, account)
    list = Playlist.new
    list.title = yt_playlist.title
    list.youtube_id = yt_playlist.id
    list.creator = init_creator(yt_playlist.channel_id)
    list.thumbnail = yt_playlist.thumbnail_url
    list.description = yt_playlist.description
    list.init_playlist_video(yt_playlist.playlist_items)
    list.init_playlist_watcher(account)
  end

  def self.init_playlists(playlists, account)
    playlists.each do |yt_playlist|
      list = Playlist.initialize_with_yt(yt_playlist, account)
      list.save!
    end
  end

  def init_playlist_video(items)
    items.each do |item|
      playlist_video = PlaylistVideo.new(self, item)
      next if playlist_video.video.nil?

      playlist_video.save!
    end
  end

  def init_playlist_watcher(account)
    watcher = PlaylistWatcher.new(self, account)
    watcher.save!
  end
end
