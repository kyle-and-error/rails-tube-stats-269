class WatchedVideo < ApplicationRecord
  belongs_to :watch
  belongs_to :video

  validates :like_status, :datetime_watched, presence: true
  enum like_status: %i[not_liked liked disliked]

  def initialize(watch, video, like_status)
    self.watch = watch
    self.like_status = 0 if like_status == false
    self.like_status = 1 if like_status == true
    self.datetime_watched = DateTime.now
    self.video = video
  end

  def self.init_watched_videos(video, like_status)
    watch = Watch.where(watcher: self, creator: video.creator).take
    watch_video = WatchedVideo.new(watch, video, like_status)
    watch_video.save!
  end
end
