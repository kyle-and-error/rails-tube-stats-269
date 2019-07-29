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
end
