class Video < ApplicationRecord
  belongs_to :creator

  has_many :watched_videos
  has_many :comments, through: :watched_videos

  has_many :playlist_videos
  has_many :playlists, through: :playlist_videos

  has_many :suggestions

  validates :title, :youtube_id, presence: true

  def self.init_video(account, list, video_id)
    video = Video.where(youtube_id: video_id).take
    if video.nil?
      yt_video = Yt::Video.new id: video_id, auth: account
      begin
        creator = Creator.init_creator(yt_video.channel_id, account)
        yt_params = {categlry: yt_video.category_title,creator: creator, youtube_id: yt_video.id, title: yt_video.title, description: yt_video.description, thumbnail: yt_video.thumbnail_url, length: yt_video.duration}
        video = Video.new(yt_params)
        WatchedVideo.init_watched_videos(video, yt_video.liked?)
      rescue Yt::Errors::NoItems
        return nil
      end
      video.save!
    end
    video
  end
end
