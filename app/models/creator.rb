class Creator < ApplicationRecord
  has_many :watches
  has_many :watchers, through: :watches, class_name: "YoutubeAccount"
  has_many :playlists
  has_many :videos

  def self.init_creator(channel_id, account)
    creator = Creator.where(youtube_id: channel_id).take
    if creator.nil?
      yt_channel = Yt::Channel.new id: channel_id, auth: account
      creator = Creator.new(yt_channel)
      creator.save!
      unless creator.youtube_id == @youtube_id
        Watch.init_watches(creator, yt_channel.subscribed?)
      end
    end
    creator
  end

  def url
    'https://www.youtube.com/channel/' + youtube_id
  end

  def initialize(yt_channel)
    self.youtube_id = yt_channel.id
    self.title = yt_channel.title
    self.description = yt_channel.description
    self.thumbnail = yt_channel.thumbnail_url
  end
end
