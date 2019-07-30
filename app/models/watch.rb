class Watch < ApplicationRecord
  belongs_to :watcher, foreign_key: 'watcher_id', class_name: 'YoutubeAccount'
  belongs_to :creator
  has_many :watched_videos
  has_many :videos, through: :watched_videos

  def self.init_watches(account, creator, subscribed)
    watcher = Watch.where(watcher: account, creator: creator).take
    if watcher.nil?
      watcher = Watch.new(creator: creator, watcher: account)
    end
    watcher.subscription = subscribed
    watcher.save!
  end
end
