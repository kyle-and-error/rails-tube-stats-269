require 'google/apis/youtube_v3'
require 'google/api_client/client_secrets'
class PagesController < ApplicationController
  DOMAIN = ENV["DOMAIN"]
  skip_before_action :authenticate_user!, only: [:home, :privacy_policy]
  before_action :authorize_url

  def home
  end

  def data
    watches = Watch.where(watcher: current_user.youtube_accounts[0])
    watches.each do |watch|
      watch.total_watch_time
    end
    @bar_function = ((10 / watches) * 100).to_i
    @color_function = "12,24,58"
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
