class WatchedVideo < ApplicationRecord
  belongs_to :watch
  belongs_to :video

  validates :like_status, :datetime_watched, presence: true
  enum like_status: %i[not_liked liked disliked]

  def self.init_watched_videos(watcher, video, like_status)
    watch_a = Watch.where(watcher: watcher, creator: video.creator).take
    watch_video = WatchedVideo.new(watch: watch_a, datetime_watched: DateTime.now, video: video)
    watch_video.like_status = 0 if like_status == false
    watch_video.like_status = 1 if like_status == true
    watch_video.save!
  end
end
