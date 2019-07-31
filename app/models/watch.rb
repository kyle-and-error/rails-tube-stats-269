class Watch < ApplicationRecord
  belongs_to :watcher, foreign_key: 'watcher_id', class_name: 'YoutubeAccount'
  belongs_to :creator
  has_many :watched_videos
  has_many :videos, through: :watched_videos

  def self.init_watches(watcher, creator, subscribed)
    watch = Watch.where(watcher: watcher, creator: creator).take
    if watch.nil?
      watch = Watch.new(creator: creator, watcher: watcher)
    end
    watch.subscription = subscribed
    watch.save!
  end

  def self.top_watched_by(watcher)
    watches_all = Watch.where(watcher: watcher).to_a
    watches_all.sort do |a, b|
      b.total_watch_time <=> a.total_watch_time
    end
    watches_all
  end

  def self.absolute_total_time(watcher)
    watches_all = Watch.where(watcher: watcher).to_a
    absolute_total = 0
    watches_all.each do |watch|
      absolute_total = watch.total_watch_time
    end
    absolute_total
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
