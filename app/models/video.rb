class Video < ApplicationRecord
  belongs_to :creator

  has_many :watched_videos

  has_many :playlist_videos
  has_many :playlists, through: :playlist_videos

  has_many :suggestions

  validates :title, :youtube_id, :length, presence: true

  def self.init_video(account, video_id)
    video = Video.where(youtube_id: video_id).take
    if video.nil?
      yt_video = Yt::Video.new id: video_id, auth: account
      begin
        watcher = YoutubeAccount.find_by_youtube_account(account)
        creator = Creator.init_creator(yt_video.channel_id, account)
        yt_params = { category: yt_video.category_title, creator: creator, youtube_id: yt_video.id, title: yt_video.title, description: yt_video.description, thumbnail: yt_video.thumbnail_url, length: yt_video.duration }
        video = Video.new(yt_params)
        WatchedVideo.init_watched_videos(watcher, video, yt_video.liked?)
      rescue Yt::Errors::NoItems
        return nil
      end
      video.save!
    end
    video
  end
end
