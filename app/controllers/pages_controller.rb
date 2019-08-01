require 'google/apis/youtube_v3'
require 'google/api_client/client_secrets'
class PagesController < ApplicationController
  DOMAIN = ENV["DOMAIN"]
  HTTP = "http"
  HTTP = "https" if DOMAIN.include?('tube-stats')
  skip_before_action :authenticate_user!, only: [:home, :privacy_policy]
  before_action :authorize_url

  def home
  end

  def data
    youtube_account = YoutubeAccount.find(params["youtube_account_id"])
    @all = Watch.top_watched_by(youtube_account)
    @first_five = []
    @all.each do |watch|
      @first_five << watch unless @first_five.map {|w| w.creator}.include?(watch.creator)
    end
    @first_five = @first_five.first(5)
    @first_five_sum = Watch.total_time(@first_five)
    @last = @all.drop(5)
    @last_sum = Watch.total_time(@last)
    @absolute_total = Watch.absolute_total_time(youtube_account)
    @color_function = "12,24,58"
  end

  def dashboard
    youtube_account = current_user.youtube_accounts.first
    @authorization_url = authorization_url
    @all = Watch.top_watched_by(youtube_account)
    @first_five = @all.first(5)
    @first_five_sum = Watch.total_time(@first_five)
    @last = @all.drop(5)
    @last_sum = Watch.total_time(@last)
    @absolute_total = Watch.absolute_total_time(youtube_account)
    @color_function = "12,24,58"
  end

  def privacy_policy
  end

  def authorization_url
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      scope: ['https://www.googleapis.com/auth/youtube', 'https://www.googleapis.com/auth/youtube.readonly', 'https://www.googleapis.com/auth/userinfo.email'],
      redirect_uri: "#{HTTP}://#{DOMAIN}/youtube_accounts/new",
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
