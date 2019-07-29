require 'google/api_client/client_secrets'
# require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
class YoutubeAccount < ApplicationRecord
  YOUTUBE_SCOPE = ['https://www.googleapis.com/auth/youtube.readonly', 'https://www.googleapis.com/auth/youtube.readonly', 'https://www.googleapis.com/auth/userinfo.email']
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'
  PROGRAM_NAME = 'Tube Stats'

  belongs_to :user

  has_many :playlist_watchers, dependent: :destroy
  has_many :playlists, through: :playlist_watchers
  has_many :playlist_videos, through: :playlists

  has_many :watches, dependent: :destroy
  has_many :creators, through: :watches
  has_many :watched_videos, through: :watches
  has_many :videos, through: :watched_videos
  has_many :comments, through: :watched_videos

  has_many :suggestions, dependent: :destroy

  has_many :video_watched, through: :watchex

  validates :email, uniqueness: true

  before_save :initialize_data
  after_save :initialize_more_data

  def url
    'https://www.youtube.com/channel/' + youtube_id
  end

  private
  def init_creator(channel_id)
    creator = Creator.where(youtube_id: channel_id).take
    if creator.nil?
      yt_channel = Yt::Channel.new id: channel_id, auth: @account
      creator = Creator.new
      creator.youtube_id = yt_channel.id
      creator.title = yt_channel.title
      creator.description = yt_channel.description
      creator.thumbnail = yt_channel.thumbnail_url
      creator.save!
      unless creator.youtube_id == @youtube_id
        init_watches(creator, yt_channel.subscribed?)
      end
    end
    creator
  end

  def init_watches(creator, subscribed)
    watcher = Watch.where(watcher: self, creator: creator).take
    if watcher.nil?
      watcher = Watch.new
      watcher.creator = creator
      watcher.watcher = self
    end
    watcher.subscription = subscribed
    watcher.save!
  end

  def initialize_data
    Yt.configuration.log_level = :debug
    Yt.configuration.client_id = '546111180417-nu0vq86o5tilefhoiuvgo9fluvlgaof7.apps.googleusercontent.com'
    Yt.configuration.client_secret = 'S8K_ZRtM711nSqsoMmCwo_3p'
    @account = Yt::Account.new refresh_token: refresh_token
    youtube_id = @account.channel.id
    @youtube_id = youtube_id
    email = @account.email
    username = @account.name
    username = email if username.nil?
    avatar = @account.avatar_url
    location = @account.locale
    name = username if name.nil?
    init_creator(youtube_id)
  end

  def initialize_more_data
    init_playlists(@account.playlists)
    init_playlists(@account.related_playlists)
    init_history
  end

  def init_watched_videos(video, like_status)
    watch_video = WatchedVideo.new
    watch_video.watch = Watch.where(watcher: self, creator: video.creator).take
    watch_video.like_status = 0 if like_status == false
    watch_video.like_status = 1 if like_status == true
    watch_video.datetime_watched = DateTime.now
    watch_video.video = video
    watch_video.save!
  end

  def init_video(list, video_id)
    video = Video.where(youtube_id: video_id).take
    if video.nil?
      yt_video = Yt::Video.new id: video_id, auth: @account
      video = Video.new youtube_id: yt_video.id
      begin
        video.title = yt_video.title
        video.description = yt_video.description
        video.thumbnail = yt_video.thumbnail_url
        video.length = yt_video.duration
        video.creator = init_creator(yt_video.channel_id)
        init_watched_videos(video, yt_video.liked?)
      rescue Yt::Errors::NoItems
        return nil
      end
      video.save!
    end
    video
  end

  def init_playlist_video(list, items)
    items.each do |item|
      playlist_video = PlaylistVideo.new
      playlist_video.playlist = list
      playlist_video.video = init_video(list, item.video_id)
      next if playlist_video.video.nil?

      playlist_video.save!
    end
  end

  def init_playlist_watcher(list)
    watcher = PlaylistWatcher.new
    watcher.playlist = list
    watcher.watcher = self
    watcher.save!
  end

  def get_authenticated_service
    client = Google::APIClient.new(
      application_name: PROGRAM_NAME,
      application_version: '1.0.0'
    )
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    file_storage = Google::APIClient::FileStorage.new("client_secrets.json")
    if file_storage.authorization.nil?
      client_secrets = Google::APIClient::ClientSecrets.load
      flow = Google::APIClient::InstalledAppFlow.new(
        client_id: client_secrets.client_id,
        client_secret: client_secrets.client_secret,
        scope: YOUTUBE_SCOPE
      )
      client.authorization = flow.authorize(file_storage)
    else
      client.authorization = file_storage.authorization
    end

    return client, youtube
  end

  def init_history
    client, youtube = get_authenticated_service
    begin
      # Retrieve the "contentDetails" part of the channel resource for the
      # authenticated user's channel.
      channels_response = client.execute!(
        api_method: youtube.channels.list,
        parameters: {
          mine: true,
          part: 'contentDetails'
        }
      )

      channels_response.data.items.each do |channel|
        history = Playlist.new title: 'History'
        history.youtube_id = yt_playlist.id
        history.creator = init_creator(self.youtube_id)
        # From the API response, extract the playlist ID that identifies the list
        # of videos uploaded to the authenticated user's channel.
        history_list_id = channel['contentDetails']['relatedPlaylists']['watchHistory']

        # Retrieve the list of videos uploaded to the authenticated user's channel.
        next_page_token = ''
        until next_page_token.nil?
          playlistitems_response = client.execute!(
            api_method: youtube.playlist_items.list,
            parameters: {
              playlistId: history_list_id,
              part: 'snippet',
              maxResults: 50,
              pageToken: next_page_token
            }
          )

          # Print information about each video.
          items = []
          playlistitems_response.data.items.each do |playlist_item|
            items << Yt::Video.new(id: playlist_item['snippet']['resourceId']['videoId'])
          end
          init_playlist_video(history, items)
          init_playlist_watcher(history)

          next_page_token = playlistitems_response.next_page_token
        end
      end
      history.save!
    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
    end
  end

  def init_playlists(playlists)
    playlists.each do |yt_playlist|
      list = Playlist.new title: yt_playlist.title
      puts "PLAYLIST TITLE: #{list.title}"
      list.youtube_id = yt_playlist.id
      list.creator = init_creator(yt_playlist.channel_id)
      list.thumbnail = yt_playlist.thumbnail_url
      list.description = yt_playlist.description
      init_playlist_video(list, yt_playlist.playlist_items)
      init_playlist_watcher(list)
      list.save!
    end
  end
end
