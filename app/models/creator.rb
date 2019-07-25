class Creator < ApplicationRecord
  has_many :watches
  has_many :watchers, through: :watches, class_name: "YoutubeAccount"
  has_many :playlists
  has_many :videos

  def subscribe_url
    url + '?sub_confirmation=1'
  end

  before_save :set_id

  private

  def set_id
  end
end
