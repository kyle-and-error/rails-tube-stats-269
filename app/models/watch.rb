class Watch < ApplicationRecord
  belongs_to :watcher, foreign_key: 'watcher_id', class_name: 'YoutubeAccount'
  belongs_to :creator
  has_many :watched_videos
  has_many :videos, through: :watched_videos

  def initialize(account, creator)
    self.creator = creator
    self.watcher = account
  end

  def self.init_watches(creator, subscribed)
    watcher = Watch.where(watcher: self, creator: creator).take
    if watcher.nil?
      watcher = Watch.new(self, creator)
    end
    watcher.subscription = subscribed
    watcher.save!
  end

  def latest_video_watched
    watched_videos.to_a.max_by {|o| o[:datetime_watched]}
  end

  def total_watch_time
    time = 0
    videos.each do |video|
      time += video.length
    end
    time
  end

  def self.least_watched_by(watcher)
    watches = Watch.where(watcher: watcher).to_a
    watches.sort do |a, b|
      a.total_watch_time <=> b.total_watch_time
    end
    puts watches.first
    puts watches.last
    watches.last
  end
end
