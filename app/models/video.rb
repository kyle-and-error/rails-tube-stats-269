class Video < ApplicationRecord
  belongs_to :creator

  has_many :watched_videos
  has_many :comments, through: :watched_videos

  has_many :playlist_videos
  has_many :playlists, through: :playlist_videos

  has_many :suggestions

  validates :title, :youtube_id, presence: true

  def initialize(yt_video)
    self.youtube_id = yt_video.id
    self.title = yt_video.title
    self.description = yt_video.description
    self.thumbnail = yt_video.thumbnail_url
    self.length = yt_video.duration
  end

  def self.init_video(list, video_id)
    video = Video.where(youtube_id: video_id).take
    if video.nil?
      yt_video = Yt::Video.new id: video_id, auth: @account
      begin
        video = Video.new(yt_video)
        video.creator = Creator.init_creator(yt_video.channel_id)
        WatchedVideo.init_watched_videos(video, yt_video.liked?)
      rescue Yt::Errors::NoItems
        return nil
      end
      video.save!
    end
    video
  end
end
