class Comment < ApplicationRecord
  belongs_to :youtube_account
  belongs_to :videos, dependent: :destroy

  validates :text, presence: true
end
