class Creator < ApplicationRecord
  has_many :watches
  has_many :watchers, through: :watches, class_name: "YoutubeAccount"
  has_many :playlists
  has_many :videos

  def self.init_creator(channel_id, account)
    creator = Creator.where(youtube_id: channel_id).take
    if creator.nil?
      yt_channel = Yt::Channel.new id: channel_id, auth: account
      creator = Creator.create!(youtube_id: yt_channel.id, title: yt_channel.title, description: yt_channel.description, thumbnail: yt_channel.thumbnail_url)
      Watch.init_watches(account, creator, yt_channel.subscribed?) unless creator.youtube_id == @youtube_id
    end
    creator
  end

  def url
    'https://www.youtube.com/channel/' + youtube_id
  end
end
