class Creator < ApplicationRecord
  has_many :watches
  has_many :watchers, through: :watches, class_name: "YoutubeAccount"
  has_many :playlists
  has_many :videos

  def url
    'https://www.youtube.com/channel/' + youtube_id
  end

end
