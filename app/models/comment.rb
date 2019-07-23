class Comment < ApplicationRecord
  belongs_to :watcher, class_name: 'YoutubeAccount'
  belongs_to :videos, dependent: :destroy

  validates :text, presence: true
end
