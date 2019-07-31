require 'google/apis/youtube_v3'
require 'google/api_client/client_secrets'
class PagesController < ApplicationController
  DOMAIN = ENV["DOMAIN"]
  skip_before_action :authenticate_user!, only: [:home, :privacy_policy]
  before_action :authorize_url

  def home
  end

  def data
    # youtube_account = YoutubeAccount.find(params["youtube_account_id"])
    # watches = Watch.top_watched_by(youtube_account)
    # absolute_total = Watch.absolute_total_time(youtube_account)
    @bar_functions = []
   # watches.each do |watch|
   #   @bar_functions << ((watch.total_watch_time / absolute_total) * 100).to_i
    #  @color_function = "12,24,58"
   # end
  end

  def dashboard
    @authorization_url = authorization_url
  end

  def privacy_policy
  end

  def authorization_url
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      scope: ['https://www.googleapis.com/auth/youtube', 'https://www.googleapis.com/auth/youtube.readonly', 'https://www.googleapis.com/auth/userinfo.email'],
      redirect_uri: "http://#{DOMAIN}/youtube_accounts/new",
      additional_parameters: {
        "access_type" => "offline",         # offline access
        "include_granted_scopes" => "true"  # incremental auth
      }
    )
    auth_client.authorization_uri.to_s
  end

  private

  def authorize_url
    @authorization_url = authorization_url
  end
end
