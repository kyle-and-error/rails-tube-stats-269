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

  def self.find_by_youtube_account(yt)
    YoutubeAccount.where(youtube_id: yt.channel.id).take
  end

  def update
    init_history
  end

  private

  def initialize_data
    Yt.configuration.log_level = :debug
    Yt.configuration.client_id = '546111180417-nu0vq86o5tilefhoiuvgo9fluvlgaof7.apps.googleusercontent.com'
    Yt.configuration.client_secret = 'S8K_ZRtM711nSqsoMmCwo_3p'
    @account = Yt::Account.new refresh_token: refresh_token
    set_values
    Creator.init_creator(@youtube_id, @account)
  end

  def set_values
    self.youtube_id = @account.channel.id
    @youtube_id = youtube_id
    self.email = @account.email
    self.username = @account.name
    self.username = email if username.nil?
    self.name = username if name.nil?
    self.avatar = @account.avatar_url
    self.location = @account.locale
  end

  def initialize_more_data
    Playlist.init_playlists(@account.playlists, @account)
    Playlist.init_playlists(@account.related_playlists, @account)
  end

  def get_authenticated_service
    client = Google::APIClient.new(
      # application_name: PROGRAM_NAME,
      # application_version: '1.0.0'
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
          history.init_playlist_video(items)
          history.init_playlist_watcher(self.account)

          next_page_token = playlistitems_response.next_page_token
        end
      end
      history.save!
    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
    end
  end
end
