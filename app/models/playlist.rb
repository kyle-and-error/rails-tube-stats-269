class Playlist < ApplicationRecord
  belongs_to :creator

  has_many :playlist_watchers

  has_many :playlist_videos
  has_many :videos, through: :playlist_videos

  has_many :suggestions

  validates :title, presence: true

  def self.find_history(watcher)
    watcher_lists = PlaylistWatcher.where(watcher: watcher).to_a
    watcher_history = Playlist.new
    watcher_history = watcher_lists.select { |list| list.title == "History" }.first
    watcher_history
  end

  def self.init_playlist(yt_playlist, watcher)
    list = Playlist.where(youtube_id: yt_playlist.id).take
    if list.nil?
      list = Playlist.new(creator: Creator.init_creator(yt_playlist.channel_id, watcher), title: yt_playlist.title)
      list.youtube_id = yt_playlist.id
      list.thumbnail = yt_playlist.thumbnail_url
      list.description = yt_playlist.description
      list.init_playlist_video(yt_playlist.playlist_items, watcher)
      list.init_playlist_watcher(watcher)
      list.save!
    end
    list
  end

  def self.init_playlists(playlists, account)
    playlists.each do |yt_playlist|
      Playlist.init_playlist(yt_playlist, account)
    end
  end

  def init_playlist_video(items, account)
    items.each do |item|
      playlist_video = PlaylistVideo.new(playlist: self, video: Video.init_video(account, item.video_id))
      next if playlist_video.video.nil?

      playlist_video.save!
    end
  end

  def init_playlist_watcher(account)
    watcher = YoutubeAccount.find_by_youtube_account(account)
    PlaylistWatcher.create!(playlist: self, watcher: watcher)
  end
end
