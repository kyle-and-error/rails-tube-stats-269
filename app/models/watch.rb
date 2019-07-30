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
end
