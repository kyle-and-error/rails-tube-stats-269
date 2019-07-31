require "open-uri"
require "nokogiri"
class Creator < ApplicationRecord
  has_many :watches
  has_many :watchers, through: :watches, class_name: "YoutubeAccount"
  has_many :playlists
  has_many :videos

  before_save :get_avatar

  def self.init_creator(channel_id, yt_account)
    creator = Creator.where(youtube_id: channel_id).take
    if creator.nil?
      yt_channel = Yt::Channel.new id: channel_id, auth: yt_account
      watcher = YoutubeAccount.find_by_youtube_account(yt_account)
      creator = Creator.new(youtube_id: yt_channel.id, title: yt_channel.title, description: yt_channel.description, thumbnail: yt_channel.thumbnail_url)
      creator.save!
      Watch.init_watches(watcher, creator, yt_channel.subscribed?) unless watcher.nil?
    end
    creator
  end

  def url
    'https://www.youtube.com/channel/' + youtube_id
  end

  def get_avatar
    # source = open(url).read
    channel_url = url
    html_file = open(channel_url).read
    html_doc = Nokogiri::HTML(html_file)

    self.avatar = html_doc.css('img').first.attributes["src"].value
  end
end
