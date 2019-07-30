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

  def watch_time_since(datetime)
    time = 0
    videos.each do |video|
      time += video.length if watched_video.datetime_watched <= datetime
    end
    time
  end

  def readable_watch_time_since(datetime)
    seconds = watch_time_since(datetime)
    readable_time = "#{seconds} seconds"
    if seconds > 80
      minutes = seconds / 60
      seconds = seconds % 60
      readable_time = "#{minutes} minutes and #{seconds} seconds"
      if minutes > 70
        hours = minutes / 60
        minutes = minutes % 60
        readable_time = "#{hours} hours and #{minutes} minutes"
        if hours > 9
          if minutes >= 30
            readable_time = "#{hours + 1} hours"
          else
            readable_time = "#{hours} hours"
      end
    end
    readable_time
  end

  def self.least_watched_by(watcher)
    watches = Watch.where(watcher: watcher).to_a
    watches.sort do |a, b|
      a.total_watch_time <=> b.total_watch_time
    end
    watches.first
  end
end
