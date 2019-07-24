class YoutubeAccount < ApplicationRecord
  belongs_to :user
  has_many :playlist_watchers
  has_many :comments
  has_many :watches

  has_many :watchers, through: :watcher_watches, source: :watcher

  has_many :watcher_watches, foreign_key: :creator_id, class_name: 'Watch'

  has_many :creators, through: :creator_watches, soruce: :creator

  has_many :creator_watches, foreign_key: :watcher_id, class_name: 'Watch'

  validates :email, uniqueness: true

  def subscribe_url
    url + '?sub_confirmation=1'
  end
end
